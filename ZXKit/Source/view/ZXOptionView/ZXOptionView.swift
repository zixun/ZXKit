//
//  ZXOptionView.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/7/10.
//  Copyright © 2015年 zixun. All rights reserved.
//

import UIKit

typealias ZXOptionViewCellPoint = AutoreleasingUnsafeMutablePointer<ZXOptionViewCell>

// MARK: - ZXOptionViewDelegate
@objc protocol ZXOptionViewDelegate :NSObjectProtocol{
    
    func numberOfOptionsInOptionView(optionView:ZXOptionView) -> Int
    
    func optionView(optionView:ZXOptionView, itemSizeAtIndex index:Int) ->CGSize
    
    func optionView(optionView:ZXOptionView, cellConfiguration cellPoint:ZXOptionViewCellPoint)
    
    optional func optionView(optionView:ZXOptionView, didSelectOptionAtIndex index:Int)
}

enum ZXOptionViewType:Int {
    case Tap    = 0
    case Slider = 1
}

// MARK: - ZXOptionView
class ZXOptionView: UICollectionView{

    weak var optionDelegate: ZXOptionViewDelegate?
    
    var floatIndex: Float = 0.0 {
        didSet{
            self.type = .Slider
            self.handleFloatIndex(floatIndex)
        }
    }
    
    private var selectIndex: Int = 0
    
    var type:ZXOptionViewType = .Slider
    
    init(frame: CGRect) {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSizeMake(100, frame.size.height)
        super.init(frame: frame, collectionViewLayout: layout)
        
        self.backgroundColor = UIColor.clearColor()
        self.delegate = self
        self.dataSource = self
        self.pagingEnabled = false
        self.bounces = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        self.registerClass(ZXOptionViewCell.self, forCellWithReuseIdentifier: "ZXOptionViewCell")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
// MARK: Private Method
extension ZXOptionView {
    
    private func handleFloatIndex(floatIndex:Float) {
        
        if floatIndex - Float(Int(floatIndex)) == 0 {
            self.selectIndex = Int(floatIndex)
            return
        }
        
        let handle = self.calculateFloatIndex(floatIndex)
        self.cellforOptionAtIndex(handle.floor).textLabel.textColor = decimalColor(handle.decimal)
        self.cellforOptionAtIndex(handle.ceilf).textLabel.textColor = decimalColor(1.0 - handle.decimal)
        self.contentOffset = self.contentOffsetAt(floatIndex)
    }
    
    private func decimalColor(decimal:CGFloat) ->UIColor {
        let startColor = UIColor.whiteColor()
        let endColor = UIColor.grayColor()
        return ZXColor(startColor, endColor: endColor, fraction: decimal)
    }
    
    private func calculateFloatIndex(floatIndex:Float) ->(floor:Int,ceilf:Int,decimal:CGFloat) {
        
        let _floor = Int(floor(floatIndex))
        let _ceilf = Int(ceilf(floatIndex))
        let _decimal:CGFloat = CGFloat(floatIndex - floor(floatIndex))
        return (_floor,_ceilf,_decimal)
    }
    
    private func contentOffsetAt(floatIndex: Float) -> CGPoint {
        let handle = self.calculateFloatIndex(floatIndex)
        let _floorCell = self.cellforOptionAtIndex(handle.floor)
        let _ceilfCell = self.cellforOptionAtIndex(handle.ceilf)
        
        var offsetX =  _floorCell.center.x + (_ceilfCell.center.x - _floorCell.center.x) * handle.decimal - self.frame.size.width / 2.0
        offsetX = min(max(0, offsetX), self.contentSize.width - self.frame.size.width)
        return CGPoint(x: offsetX, y: 0)
    }
    
    private func cellforOptionAtIndex(index:Int) -> ZXOptionViewCell {
        return self.cellForItemAtIndexPath(NSIndexPath(forRow: index, inSection: 0)) as! ZXOptionViewCell
    }
}

// MARK: UICollectionViewDelegate and UICollectionViewDataSource
extension ZXOptionView : UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard self.optionDelegate != nil else {
            return 0
        }
        
        return self.optionDelegate!.numberOfOptionsInOptionView(self)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: ZXOptionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ZXOptionViewCell", forIndexPath: indexPath) as! ZXOptionViewCell
        cell.index = indexPath.row
        cell.textLabel.textColor = selectIndex == indexPath.row ? UIColor.whiteColor() : UIColor.grayColor()
        
        if self.optionDelegate != nil {
            self.optionDelegate!.optionView(self, cellConfiguration: &cell)
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        guard self.optionDelegate != nil else {
            return CGSize(width: 100, height: 44)
        }
        
        return self.optionDelegate!.optionView(self, itemSizeAtIndex: indexPath.row)
    }
    
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        //颜色处理
        if let cell_pre_selected = self.cellForItemAtIndexPath(NSIndexPath(forRow: self.selectIndex, inSection: 0)) {
            
             UIView.transitionWithView((cell_pre_selected as! ZXOptionViewCell).textLabel, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
                (cell_pre_selected as! ZXOptionViewCell).textLabel.textColor = ZXColor(0xB4B4B4)
                }, completion: nil)
        }
        
        let cell_selected:ZXOptionViewCell = self.cellForItemAtIndexPath(indexPath) as! ZXOptionViewCell
        
        UIView.transitionWithView(cell_selected.textLabel, duration: 0.3, options: .TransitionCrossDissolve, animations: { () -> Void in
            cell_selected.textLabel.textColor = UIColor.whiteColor()
            self.contentOffset = self.contentOffsetAt(Float(indexPath.row))
            }, completion: nil)
        
        self.selectIndex = indexPath.row
        
        guard self.optionDelegate != nil else{
            return
        }
        
        guard self.optionDelegate!.respondsToSelector(Selector("optionView:didSelectOptionAtIndex:")) else {
            return
        }
        self.type = .Tap
        self.optionDelegate!.optionView!(self, didSelectOptionAtIndex: indexPath.row)
    }
}


// MARK: - ZXOptionViewCell
class ZXOptionViewCell: UICollectionViewCell {
    
    var index: Int = 0
    
    var textLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.textLabel = UILabel()
        self.textLabel.font = UIFont.systemFontOfSize(14)
        self.textLabel.textAlignment = NSTextAlignment.Center
        self.textLabel.textColor = ZXColor(0xB4B4B4)
        self.contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.textLabel.fillSuperview(left: 2, right: 2, top: 0, bottom: 0)
    }
}

