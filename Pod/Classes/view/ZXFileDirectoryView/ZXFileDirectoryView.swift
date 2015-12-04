//
//  ZXFileDirectoryView.swift
//  ZXKit
//
//  Created by user on 15/12/1.
//  Copyright © 2015年 陈奕龙. All rights reserved.
//

import Foundation
import UIKit

public class ZXFileDirectoryView: ZXTreeView {
    
    public var basePath:String? {
        didSet {
            
            guard self.basePath != nil else {
                return
            }
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { () -> Void in
                self.treeItems = self.itemsAtPath("/", level: 0, parent: nil)
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.reloadData()
                })
            }
        }
    }
    
    convenience init() {
        self.init(frame:CGRectZero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        
        
    }
    

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func itemsAtPath(path:String, level:Int, parent:ZXTreeItem?) ->Array<ZXTreeItem> {
        let manager = NSFileManager.defaultManager()
        let realpath = self.basePath!.NS.stringByAppendingPathComponent(path)
        
        
        var contents = [String]()
        do {
            contents = try manager.contentsOfDirectoryAtPath(realpath)
        }catch {
            print(error)
        }
        

        //去除不需要显示的文件
        self.removeNeedNotShowFile(&contents)
        
        var subitems = Array<ZXTreeItem>(count: contents.count, repeatedValue: ZXTreeItem())
        var count = 0
        
        for name in contents {
            let subpath = path.NS.stringByAppendingPathComponent(name)
            let real = realpath.NS.stringByAppendingPathComponent(name)
            
            if manager.fileExistsAtPath(real) == false {
                continue
            }
            
            let item = ZXTreeItem()
            item.name = name
            item.path = path
            item.level = level
            item.parentItem = parent
            item.childrenItems = self.itemsAtPath(subpath, level: level + 1, parent: item)
            

            subitems[count++] = item
        }
        
        
        var result = subitems
         result = result.sort { (item1:ZXTreeItem, item2:ZXTreeItem) -> Bool in
            let sort1 = item1.isDirectory == true ? 1 : 0;
            let sort2 = item2.isDirectory == true ? 1 : 0;
            
            return sort1 > sort2
        }
        
        return result
    }
    
}


extension ZXFileDirectoryView:ZXTreeViewDelegate {
    public func treeView(treeView: ZXTreeView, didTapOnTreeItem: ZXTreeItem) {
        
    }
}

extension ZXFileDirectoryView {
    
    private func removeNeedNotShowFile(inout files:[String]) {
        for name in files {
            if name == ".git" || (name.NS.length >= 4 && name.NS.substringToIndex(4) == ".git/"){
                files.removeObject(name)
            }
            
            if name == ".DS_Store" {
                files.removeObject(name)
            }
        }
    }
}






























































