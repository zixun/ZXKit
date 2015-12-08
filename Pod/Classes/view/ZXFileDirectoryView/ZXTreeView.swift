//
//  ZXFileDirectoryView.swift
//  ZXKit
//
//  Created by user on 15/12/1.
//  Copyright © 2015年 陈奕龙. All rights reserved.
//

import Foundation
import UIKit
import Neon
import RxSwift

public class ZXTreeView: UIView {
    
    public let rx_tapTreeItem = PublishSubject<ZXTreeItem>()
    
    var treeItems = [ZXTreeItem]()
    
    private lazy var tableView: UITableView = {
        let new = UITableView()
        new.delegate = self
        new.dataSource = self
        new.rowHeight = 32.0
        new.separatorStyle = .None
        new.registerClass(ZXTreeViewCell.self, forCellReuseIdentifier: "selectingTableViewCell")
        return new
    }()
    
    public convenience init() {
        self.init(frame:CGRectZero);
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.tableView)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.fillSuperview()
    }
    
    public func reloadData() {
        self.tableView.reloadData()
    }
    
    
}

extension ZXTreeView: UITableViewDelegate,UITableViewDataSource {
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.treeItems.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectingTableViewCell") as! ZXTreeViewCell
        let treeItem = self.treeItems[indexPath.row]
        cell.configure(treeItem)
        cell.delegate = self
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ZXTreeViewCell
        
        let treeItem = self.treeItems[indexPath.row]
        self.rx_tapTreeItem.onNext(treeItem)
        let insertselectingItems = treeItem.childrenItems
        
        var insertTreeItemIndex = self.treeItems.indexOf(treeItem)!
        var insertIndexPaths = Array<NSIndexPath>()
        
        var removeIndexPaths = Array<NSIndexPath>()
        var treeItemsToRemove = Array<ZXTreeItem>()
        
        for item in insertselectingItems {
            item.path = treeItem.pathForChildren()
            item.parentItem = treeItem
            
            insertTreeItemIndex++
            
            var contains = false
            
            for tmp2TreeItem:ZXTreeItem in self.treeItems {
                if tmp2TreeItem.isEqualToSelectingItem(item) {
                    contains = true
                    self.selectingItemsToDelete(tmp2TreeItem, saveToArray: &treeItemsToRemove)
                    removeIndexPaths = self.indexPathsForTreeItems(treeItemsToRemove)
                }
            }
            
            if !contains {
                self.treeItems.insert(item, atIndex: insertTreeItemIndex)
                insertIndexPaths.append(NSIndexPath(forRow: insertTreeItemIndex, inSection: 0))
            }
            
        }
        
        if insertIndexPaths.count > 0 {
            self.tableView.insertRowsAtIndexPaths(insertIndexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            cell.open = true
        }
        
        for tmp2TreeItem in treeItemsToRemove {
            self.treeItems.removeObject(tmp2TreeItem)
        }
        
        if removeIndexPaths.count > 0 {
            self.tableView.deleteRowsAtIndexPaths(removeIndexPaths, withRowAnimation: UITableViewRowAnimation.Bottom)
            cell.open = false
            
        }
    }
    
    
    public func listItemsAtPath(path:String?) -> Array<ZXTreeItem>? {
        guard path != nil else {
            return nil
        }
        return [ZXTreeItem]()
    }
    
    
    func selectingItemsToDelete(selItems:ZXTreeItem,inout saveToArray deleteSelectingItems:Array<ZXTreeItem>) {
        for obj in selItems.childrenItems {
            self.selectingItemsToDelete(obj, saveToArray: &deleteSelectingItems)
        }
        
        deleteSelectingItems.append(selItems)
    }
    
    func indexPathsForTreeItems(items:Array<ZXTreeItem>) ->Array<NSIndexPath> {
        var result = [NSIndexPath]()
        
        for item in items {
            let index = self.treeItems.indexOf(item)
            if index != nil {//因为有可能子节点的子节点没展开 所以没有添加到treeItems上来
                let indexPath = NSIndexPath(forRow: index!, inSection: 0)
                result.append(indexPath)
            }
        }
        return result
    }
}

extension ZXTreeView:ZXTreeViewCellDelegate {
    func treeTableViewCell(cell: ZXTreeViewCell, didTapIconWithTreeItem: ZXTreeItem) {
        self.delegate?.treeView(self, didTapOnTreeItem: didTapIconWithTreeItem)
    }
}




//Model

public class ZXTreeItem: NSObject {
    var name: String?
    var path: String?
    var parentItem:ZXTreeItem?
    var childrenItems = Array<ZXTreeItem>()
    var level:Int = 0
    
    var isDirectory:Bool {
        get {
            return self.childrenItems.count > 0
        }
    }
    
    override init() {
        super.init()
    }
    
    //是否有孩子节点
    func hasChildren() -> Bool {
        return self.childrenItems.count > 0
    }
    
    func pathForChildren() ->String? {
        //TODO
        return self.path?.NS.stringByAppendingPathComponent(name!)
    }
    
    func isEqualToSelectingItem(selectingItem:ZXTreeItem) ->Bool {
        return self.name == selectingItem.name && self.path == selectingItem.path
    }
}















