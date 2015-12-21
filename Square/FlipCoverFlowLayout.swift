//
//  FlipCoverFlowLayout.swift
//  Square
//
//  Created by Bers on 15/12/6.
//  Copyright © 2015年 Bers. All rights reserved.
//

import UIKit

class FlipCoverFlowLayout: UICollectionViewFlowLayout {
    
    var zoomFactor = CGFloat(0.35)
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let array = super.layoutAttributesForElementsInRect(rect)
        assert(self.collectionView != nil)
        var visibleRect = CGRectZero
        visibleRect.origin = self.collectionView!.contentOffset
        visibleRect.size = self.collectionView!.bounds.size
        let halfFrame = self.collectionView!.frame.size.width / 2.0
        
        for attributes in array! {
            if CGRectIntersectsRect(attributes.frame, rect) {
                let distance = CGRectGetMidX(visibleRect) - attributes.center.x
                let normalizedDistance = distance / halfFrame
                if abs(distance) < halfFrame {
                    let zoom = 1 + self.zoomFactor*(1-abs(normalizedDistance))
                    var transform = CATransform3DIdentity
                    transform.m34 = CGFloat(1.0 / -500)
                    transform = CATransform3DRotate(transform, normalizedDistance*CGFloat(M_PI_4), 0.0, 1.0, 0.0)
                    let zoomTransform = CATransform3DMakeScale(zoom, zoom, zoom)
                    attributes.transform3D = CATransform3DConcat(zoomTransform, transform)
                    attributes.zIndex = Int(abs(normalizedDistance) * 10.0)
                    var alpha = (1-abs(normalizedDistance)) + 0.1
                    if alpha > 1.0 {
                        alpha = 1.0
                    }
                    attributes.alpha = alpha
                }else {
                    attributes.alpha = 0.0
                }
            }
        }
        return array;
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func prepareLayout() {
        self.scrollDirection = .Horizontal;
        let size = self.collectionView!.frame.size;
        let num = ceil(size.width / (size.height * 0.6))
        let sideLength = size.width / CGFloat(num)
        print("SideLength: \(sideLength)\nH: \(size.height)")
        self.itemSize = CGSizeMake(sideLength, sideLength);
        self.sectionInset = UIEdgeInsetsMake(0, size.height * 0.1, 0, size.height * 0.1);
    }
}

class FlipCoverLayout: UICollectionViewLayout {

    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(self.collectionView.)
    }

}