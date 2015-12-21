//
//  ProjectionModel.swift
//  Square
//
//  Created by Bers on 15/12/7.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

class ProjectionLocalModel: NSObject, NSCoding {
    
    var identifier : String
    var modelFilePath : NSURL
    var title : String
    var previewImagePath : NSURL
    var detailDescription : String
    override var description : String {
        return "{\n\tIdentifier:\(self.identifier)\n\tModelFile:\(self.modelFilePath.absoluteString)\n\tTitle:\(self.title)\n\tPreviewImage:\(self.previewImagePath.absoluteString)\n\tDescription:\(self.detailDescription)\n}"
    }
    
    init(identifier: String, filePath: NSURL, title:String, description:String, previewImagePath: NSURL){
        self.identifier = identifier
        self.modelFilePath = filePath
        self.title = title
        self.detailDescription = description
        self.previewImagePath = previewImagePath
        super.init()
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(identifier, forKey: "identifier")
        aCoder.encodeObject(modelFilePath.absoluteString, forKey: "modelFilePath")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeObject(previewImagePath.absoluteString, forKey: "thunmImagePath")
        aCoder.encodeObject(detailDescription, forKey: "description")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.identifier = aDecoder.decodeObjectForKey("identifier") as! String
        self.modelFilePath = NSURL(fileURLWithPath: aDecoder.decodeObjectForKey("modelFilePath") as! String)
        self.title = aDecoder.decodeObjectForKey("title")  as! String
        self.previewImagePath = NSURL(fileURLWithPath: aDecoder.decodeObjectForKey("thumbImagePath") as! String)
        self.detailDescription = aDecoder.decodeObjectForKey("description") as! String
        super.init()
    }
    
}
