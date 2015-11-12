//
//  ZXPagingView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/6/21.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

/// 放内容的Page
class ZXPage: UICollectionViewCell {
    
    var index:Int?
}

protocol ZXPagingViewDelegate: NSObjectProtocol {
    
    func numberOfItemsInPagingView(pagingView:ZXPagingView) -> Int
    
    func pagingView(pagingView:ZXPagingView, cellForPageAtIndex index: Int) -> ZXPage
    
    func pagingView(pagingView:ZXPagingView,movingFloatIndex floatIndex:Float)
    
    func pagingView(pagingView:ZXPagingView, didMoveToPageAtIndex index:Int)
    
    func pagingView(pagingView:ZXPagingView, willMoveToPageAtIndex index:Int)
    
}

class ZXPagingView: UICollectionView, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDataSource {
    
    weak var pagingDelegate:ZXPagingViewDelegate?
    
    var currentIndex:Int = 0 {
        
        didSet{
            self.moveToIndex(currentIndex)
        }
    }
    
    override var frame: CGRect {
        didSet {
            let layout = self.collectionViewLayout as! UICollectionViewFlowLayout
            if !CGSizeEqualToSize(layout.itemSize, frame.size) {
                
                layout.itemSize = frame.size
                layout.invalidateLayout()
            }
        }
    }
    
    
    init(frame: CGRect) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = frame.size
        
        super.init(frame: frame, collectionViewLayout: layout)

        self.delegate = self
        self.dataSource = self
        self.pagingEnabled = true
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func reloadItemsAtIndex(index: Int) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        self.reloadItemsAtIndexPaths([indexPath])
    }

    func moveToIndex(index:Int) {
        let offset = CGPointMake(self.frame.size.width * CGFloat(index), 0)
        self.setContentOffset(offset, animated: true)
    }
    
    func pageAtLocation(location:CGPoint) -> ZXPage?{
        guard CGRectContainsPoint(self.bounds, location) else {
            return nil
        }
        
        let index = Int(location.x / self.bounds.size.width)
        
        let pages = self.visibleCells() as! [ZXPage]
        
        for page in pages {
            if page.index == index {
                return page
            }
        }
        
        return nil
    }
    
    
    func dequeueReusablePageWithReuseIdentifier(identifier: String, forIndex index: Int) -> ZXPage {
        let page = self.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: NSIndexPath(forRow: index, inSection: 0) ) as! ZXPage
        page.index = index
        
        return page
    }
    
    // MARK: pagingView scroll delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        guard self.collectionView(self, numberOfItemsInSection: 0) != 0 else {
            return
        }
        
        _callMovingDelegateIfNeeded(scrollView)
    }
    
    // MARK: pagingView dataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pagingDelegate != nil ? self.pagingDelegate!.numberOfItemsInPagingView(self) : 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        guard self.pagingDelegate != nil else {
            return ZXPage()
        }
        
        let cell = self.pagingDelegate!.pagingView(self, cellForPageAtIndex: indexPath.row)
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        self.pagingDelegate?.pagingView(self, willMoveToPageAtIndex: indexPath.row)
    }
    
    // MARK: pagingView layout delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return collectionView.frame.size
    }
    
    // MARK: private method
    private func _callMovingDelegateIfNeeded(scrollView: UIScrollView) {
        
        let offsetX = scrollView.contentOffset.x
        let itemSize = (self.collectionViewLayout as! UICollectionViewFlowLayout).itemSize
        
        let floatIndex = Float(offsetX / itemSize.width)
        
        self.pagingDelegate?.pagingView(self, movingFloatIndex: floatIndex)
        
        if floatIndex - Float(Int(floatIndex)) == 0 {
            self.pagingDelegate?.pagingView(self, didMoveToPageAtIndex: Int(floatIndex))
        }
    }
    
}