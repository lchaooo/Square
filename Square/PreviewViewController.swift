//
//  PreviewViewController.swift
//  Square
//
//  Created by Bers on 15/12/6.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

//占位图片
let placeholderImage = UIImage(named: "thumb.png")

class PreviewViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //存放所有模型的Identifier
    var modelIdentifiers = [String]()
    lazy var imagesCache : NSCache! = {
        return NSCache()
    }()
    var dataManager : ProjectionDataManager!
    var currentIdentifier = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelIdentifiers = self.dataManager.allProjectionLocalModelIdentifiers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowModelDetail" {
            let detailVC = segue.destinationViewController as! DetailPreviewViewController
            detailVC.modelIdentifier = self.currentIdentifier
        }
    }
    
}

extension PreviewViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return modelIdentifiers.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCollectionCell
        assert(self.dataManager != nil)
        //获取预览图地址
        let previewImagePath = self.dataManager.projectionLocalModelWithIdentifier(self.modelIdentifiers[indexPath.row])!.previewImagePath
        
        //从缓存中获取
        var previewImage = self.imagesCache.objectForKey(previewImagePath.lastPathComponent!) as? UIImage
        cell?.imageView.image = previewImage ?? placeholderImage
        let layout = collectionView.collectionViewLayout as! FlipCoverFlowLayout
        //加载预览图
        if (previewImage == nil && previewImagePath != "") {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) { () -> Void in
                let image = UIImage(contentsOfFile: previewImagePath.absoluteString)
                UIGraphicsBeginImageContextWithOptions(layout.itemSize, true, UIScreen.mainScreen().scale)
                image?.drawInRect(CGRectMake(0, 0, layout.itemSize.width, layout.itemSize.height))
                previewImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.imagesCache.setObject(previewImage!, forKey: previewImagePath.lastPathComponent!)
                    cell?.imageView.image = previewImage
                })
            }
        }
        return cell!
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        print("Offset: \(scrollView.contentOffset)")
    }
}