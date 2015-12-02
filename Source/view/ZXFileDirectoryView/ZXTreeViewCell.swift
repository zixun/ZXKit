//
//  ZXTreeViewCell.swift
//  ZXKit
//
//  Created by user on 15/12/1.
//  Copyright © 2015年 陈奕龙. All rights reserved.
//

import Foundation
import UIKit
import Neon
import RxSwift

protocol ZXTreeViewCellDelegate:NSObjectProtocol {
    func treeTableViewCell(cell:ZXTreeViewCell,didTapIconWithTreeItem:ZXTreeItem)
}

class ZXTreeViewCell: UITableViewCell {
    
    weak var delegate:ZXTreeViewCellDelegate?
    
    var open:Bool = false {
        didSet {
            
            let imageName = open == true ? "dir_open" : "dir"
            self.iconButton.setImage(UIImage(named: imageName), forState: UIControlState.Normal)
        }
    }
    
    private lazy var iconButton: UIButton = {
        let new = UIButton()
        new.setImage(UIImage(named: "dir"), forState: .Normal)
        return new
    }()
    
    private lazy var titleTextField:UITextField = {
        let new = UITextField()
        new.font = UIFont(name: "HelveticaNeue", size: 16)
        new.textColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        new.layer.shadowColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).CGColor
        new.layer.shadowOffset = CGSizeMake(0, 1)
        new.layer.shadowOpacity = 1.0
        new.layer.shadowRadius = 0
        new.userInteractionEnabled = false
        new.backgroundColor = UIColor.clearColor()
        new.sizeToFit()
        return new
    }()
    
    
    
    private var treeItem:ZXTreeItem?
    
    private let disposeBag = DisposeBag()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //UI层级
        self.selectionStyle = .Gray
        self.layer.masksToBounds = true
        self.addSubview(self.iconButton)
        self.addSubview(self.titleTextField)
        
        //布局
        self.iconButton.anchorToEdge(Edge.Left, padding: 4, width: 24, height: 24)
        self.titleTextField.sizeToFit()
        self.titleTextField.align(Align.ToTheRightMatchingTop, relativeTo: self.iconButton, padding: 6, width: CGRectGetWidth(self.titleTextField.frame), height: CGRectGetHeight(self.titleTextField.frame))
        
        //点击
        self.iconButton
            .rx_tap
            .subscribeNext({[weak self] () -> Void in
                
                guard let sself = self else {
                    return
                }
                
                guard let respond = sself.delegate?.respondsToSelector(Selector("treeTableViewCell:didTapIconWithTreeItem:")) else {
                    return
                }
                
                if respond == true {
                    sself.delegate?.treeTableViewCell(sself, didTapIconWithTreeItem: sself.treeItem!)
                }
                
                })
            .addDisposableTo(self.disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func configure(item:ZXTreeItem) {
        self.treeItem = item
        

        if item.isDirectory {
            self.iconButton.setImage(UIImage(named: "dir"), forState: .Normal)
        }else {
            self.iconButton.setImage(UIImage(named: "code"), forState: .Normal)
        }
        
        self.titleTextField.text = item.name
        self.titleTextField.sizeToFit()
        
        self.setLevel(item.level)
    }
    
    
    func setLevel(level:Int) {
        var rect: CGRect;
        
        rect = iconButton.frame;
        rect.origin.x = 15 * CGFloat(level);
        iconButton.frame = rect;
        
        rect = titleTextField.frame;
        rect.origin.x = 30 + 15 * CGFloat(level);
        titleTextField.frame = rect;
    }
}
