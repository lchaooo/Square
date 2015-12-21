//
//  EditView.swift
//  OneSquare
//
//  Created by 李超 on 15/12/10.
//  Copyright © 2015年 李超. All rights reserved.
//

import UIKit
import SceneKit

class EditView: UIView {
    
    var filePath: String? {
        didSet {
            let fileScene = SCNScene.init(named: filePath!)
            scene?.rootNode.addChildNode(fileScene!.rootNode)
            var v1 = SCNVector3(x:0, y:0, z:0)
            var v2 = SCNVector3(x:0, y:0, z:0)
            previewView?.scene?.rootNode.getBoundingBoxMin(&v1, max:&v2)
            print(v1, v2)
            self.lookAtPosition = SCNVector3Make((v1.x + v2.x) / 2, (v1.y + v2.y) / 2, (v1.z + v2.z) / 2)
            let cameraPosition = SCNVector3Make(v1.x * 2, lookAtPosition!.y, v1.z * 2)
            cameraNode?.position = cameraPosition
            let lookAtNode = SCNNode.init()
            lookAtNode.position = lookAtPosition!
            scene?.rootNode.addChildNode(lookAtNode)
            self.cameraNode?.constraints = [SCNLookAtConstraint.init(target: lookAtNode)]
            previewView?.pointOfView = cameraNode
        }
    }
    var lookAtPosition: SCNVector3?
    var currentPointOfView: SCNNode {
        get {
            return previewView!.pointOfView!
        }
    }
//    private var
    var detailView: EditDetailView?
    private var previewView: SCNView?
    private var cameraNode: SCNNode?
    private var scene: SCNScene?
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.setUpScene();
        self.setUpSubviews();
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
    func setUpScene() {
        scene = SCNScene.init()
 
        cameraNode = SCNNode.init()
        cameraNode?.camera = SCNCamera.init()
        scene?.rootNode.addChildNode(cameraNode!)
    }
    
    func setUpSubviews() {
        previewView = SCNView.init(frame: CGRectZero, options: nil)
        self.addSubview(previewView!)
        previewView?.allowsCameraControl = true
        previewView?.snp_makeConstraints(closure: { (make) -> Void in
            make.centerX.equalTo(self.snp_centerX)
            make.top.equalTo(self.snp_top).inset(100)
            make.left.equalTo(self.snp_left).inset(30)
            make.height.equalTo(250)
        })
        previewView?.scene = scene
        
        detailView = UIView.loadFromNibNamed("EditDetailView") as? EditDetailView
        self.addSubview(detailView!)
        detailView?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(451)
            make.bottom.equalTo(self.snp_bottom)
            make.width.equalTo(self.snp_width)
            make.centerX.equalTo(self.snp_centerX)
        })
//        let button = UIButton.init(frame: CGRectMake(100, 500, 100, 100))
//        button.backgroundColor = UIColor.blackColor()
//        button.addTarget(self, action: Selector.init("log"), forControlEvents: UIControlEvents.TouchUpInside)
//        self.addSubview(button)
    }
//    func log() {
//        print(self.currentPointOfView.eulerAngles, self.currentPointOfView.position)
//    }
}
