//
//  ImageCollectionCell.swift
//  Square
//
//  Created by Bers on 15/12/6.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    var imageView : UIImageView!
    var sideInset = CGFloat(2.0)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commitInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commitInit()
    }
    
    func commitInit() {
        self.imageView = UIImageView()
        self.backgroundColor = UIColor.whiteColor()
        self.addSubview(self.imageView)
    }
    
    override func layoutSubviews() {
        self.imageView.frame = CGRectInset(self.bounds, self.sideInset, self.sideInset)
    }
    
    
}
