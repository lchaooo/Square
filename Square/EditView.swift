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
            let fileNode = fileScene!.rootNode.childNodes
            for node: SCNNode in fileNode {
                scene?.rootNode.addChildNode(node)
                node.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 1, z: 0, duration: 5)))
            }
            var smallestVector = SCNVector3Zero
            var biggestVector = SCNVector3Zero
            previewView?.scene?.rootNode.getBoundingBoxMin(&smallestVector, max:&biggestVector)
            //
            lookAtPosition = SCNVector3Make((smallestVector.x+biggestVector.x)/2, (smallestVector.y+biggestVector.y)/2, (smallestVector.z+biggestVector.z)/2)
            cameraNode?.position = self.initialCameraPosition(smallestVector, big: biggestVector)
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
        let recognizer = UIPanGestureRecognizer.init(target: self, action: Selector.init("log"))
        recognizer.minimumNumberOfTouches = 2
        previewView?.addGestureRecognizer(recognizer)
        
        detailView = UIView.loadFromNibNamed("EditDetailView") as? EditDetailView
        self.addSubview(detailView!)
        detailView?.snp_makeConstraints(closure: { (make) -> Void in
            make.top.equalTo(self.snp_top).offset(451)
            make.bottom.equalTo(self.snp_bottom)
            make.width.equalTo(self.snp_width)
            make.centerX.equalTo(self.snp_centerX)
        })
        let button = UIButton.init(frame: CGRectMake(100, 500, 100, 100))
        button.backgroundColor = UIColor.blackColor()
        button.addTarget(self, action: Selector.init("log"), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(button)
    }
    func log() {
        print("pov:\(self.currentPointOfView.nodeInfo())")
        print("node:\(self.cameraNode?.nodeInfo())")
    }
    
    func initialCameraPosition(small: SCNVector3, big: SCNVector3) -> SCNVector3 {
        let mid = SCNVector3Make((small.x+big.x)/2, (small.y+big.y)/2, (small.z+big.z)/2)
        let x = max(fabs(mid.x - small.x), fabs(mid.x - big.x))
        let y = max(fabs(mid.y - small.y), fabs(mid.y - big.y))
        let z = max(fabs(mid.z - small.z), fabs(mid.z - big.z))
        let distance = sqrt(x*x+y*y+z*z)
        return SCNVector3Make(mid.x + distance, mid.y + distance, mid.z + distance)
    }
}
