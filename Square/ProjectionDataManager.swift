//
//  ProjectionDataManager.swift
//  Square
//
//  Created by Bers on 15/12/7.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

protocol ProjectionDataManager {
    func removeProjectionLocalModelWithIdentifier(identifier:String) -> Bool
    func allProjectionLocalModelIdentifiers() -> [String]
    func projectionLocalModelWithIdentifier(identifier:String) -> ProjectionLocalModel?
    func addProjectionLocalModel(model:ProjectionLocalModel) throws
    func setPreviewImageForModelWithIdentifier(identifier: String, image: UIImage) throws
    func setTitleForModelWithIdentifier(identifier: String, title:String) throws
    func setDescriptionForModelWithIdentifier(identifier: String, description: String) throws
    func checkIfModelExistWithIdentifier(identifier: String) -> Bool
}

enum DataManagerError : ErrorType {
    case IdentifierNotExist
    case IdentifierAlreadyExist
    case ModelMissingProperty
}

class ProjectionFMDBDataManager: NSObject, ProjectionDataManager{
    
    var database : FMDatabase!
    let tableName = "ProjectionModels"
    override init() {
        super.init()
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let imageDirectory = path[0] + "/ModelImages"
        let modelDirectory = path[0] + "/ModelFiles"
        do{
            try NSFileManager.defaultManager().createDirectoryAtPath(imageDirectory, withIntermediateDirectories: true, attributes: nil)
            try NSFileManager.defaultManager().createDirectoryAtPath(modelDirectory, withIntermediateDirectories: true, attributes: nil)
        }catch let err as NSError {
            print("Create Directory Error: " + err.localizedDescription);
        }
        
        let filePath = path[0] + "/projectionModels.sqlite"
        self.database = FMDatabase(path: filePath)
        guard self.database.open() else {
            fatalError("Database opening error!")
        }
        let query = "CREATE TABLE IF NOT EXISTS \(self.tableName) ('Identifier' TEXT PRIMARY KEY, 'ModelFilePath' TEXT NOT NULL, 'ImagePath' TEXT NOT NULL, 'Title' TEXT NOT NULL, 'Description' TEXT)"
        guard self.database.executeUpdate(query, withArgumentsInArray: nil) else {
            fatalError("Create Table Error!")
        }
    }
    
    func removeProjectionLocalModelWithIdentifier(identifier: String) -> Bool {
        let query = "DELETE FROM \(self.tableName) WHERE Identifier = ?"
        return self.database.executeUpdate(query, withArgumentsInArray: [identifier])
    }
    
    func allProjectionLocalModelIdentifiers() -> [String] {
        let query = "SELECT Identifier FROM \(self.tableName)"
        let res = self.database.executeQuery(query, withArgumentsInArray: nil)
        var identifiers = [String]()
        while(res.next()){
            identifiers.append(res.stringForColumn("Identifier"))
        }
        return identifiers
    }
    
    func projectionLocalModelWithIdentifier(identifier: String) -> ProjectionLocalModel? {
        let query = "SELECT * FROM \(self.tableName) WHERE Identifier = ?"
        let res = self.database.executeQuery(query, withArgumentsInArray: [identifier])
        guard res.next() else{
            return nil
        }
        let model = ProjectionLocalModel(identifier: identifier,
            filePath: NSURL(string: res.stringForColumn("ModelFilePath"))!,
            title: res.stringForColumn("Title"),
            description: res.stringForColumn("Description"),
            previewImagePath: NSURL(string: res.stringForColumn("ImagePath"))!)
        return model
    }
    
    func addProjectionLocalModel(model: ProjectionLocalModel) throws {
        guard model.identifier != "" && model.modelFilePath.absoluteString != "" && model.title != "" else {
            throw DataManagerError.ModelMissingProperty
        }
        let query = "INSERT INTO \(self.tableName) ('Identifier', 'ModelFilePath', 'ImagePath', 'Title', 'Description') VALUES (?, ?, ?, ?, ?)"
        if !self.database.executeUpdate(query, withArgumentsInArray: [model.identifier, model.modelFilePath.absoluteString, model.previewImagePath.absoluteString, model.title, model.detailDescription]) {
            throw DataManagerError.IdentifierAlreadyExist
        }
    }
    
    func setPreviewImageForModelWithIdentifier(identifier: String, image: UIImage) throws {
        guard self.checkIfModelExistWithIdentifier(identifier) else{
            throw DataManagerError.IdentifierNotExist
        }
        // 删除原图片
        let queryPath = "SELECT ImagePath FROM \(self.tableName) WHERE Identifier = ?"
        let res = self.database.executeQuery(queryPath, withArgumentsInArray: [identifier])
        res.next()
            //原图片路径
        let origionPath = res.stringForColumn("ImagePath")
            //删除
        do{
            try NSFileManager.defaultManager().removeItemAtPath(origionPath)
        }catch let err as NSError{
            NSLog("Delete file Error: \(err.description)")
        }
        // 保存新图片
        let pngFileData = UIImagePNGRepresentation(image)
        let pngFilePath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] + "/ModelImages/" + identifier + ".png"
        pngFileData!.writeToFile(pngFilePath, atomically: true)
        
        let query = "UPDATE \(self.tableName) SET ImagePath = ? WHERE Identifier = ?"
        self.database.executeQuery(query, withArgumentsInArray: [pngFilePath, identifier])
    }
    
    func setTitleForModelWithIdentifier(identifier: String, title:String) throws {
        guard self.checkIfModelExistWithIdentifier(identifier) else{
            throw DataManagerError.IdentifierNotExist
        }
        let query = "UPDATE \(self.tableName) SET Title = ? WHERE Identifier = ?"
        self.database.executeQuery(query, withArgumentsInArray: [title, identifier])
    }
    
    func setDescriptionForModelWithIdentifier(identifier: String, description: String) throws{
        guard self.checkIfModelExistWithIdentifier(identifier) else{
            throw DataManagerError.IdentifierNotExist
        }
        let query = "UPDATE \(self.tableName) SET Description = ? WHERE Identifier = ?"
        self.database.executeQuery(query, withArgumentsInArray: [description, identifier])
    }
    
    func checkIfModelExistWithIdentifier(identifier: String) -> Bool {
        let query = "SELECT Identifier FROM \(self.tableName) WHERE Identifier = ?"
        let res = self.database.executeQuery(query, withArgumentsInArray: [identifier])
        return res.next()
    }
    
    deinit {
        self.database.close()
    }
}
