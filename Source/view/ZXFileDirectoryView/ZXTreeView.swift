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

public protocol ZXTreeViewDelegate: NSObjectProtocol {
    func treeView(treeView:ZXTreeView,didTapOnTreeItem:ZXTreeItem)
}

public class ZXTreeView: UIView {
    
    var treeItems = [ZXTreeItem]()
    
    weak var delegate:ZXTreeViewDelegate?
    
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
    
        guard cell.treeItem != nil else {
            return
        }
        self.delegate?.treeView(self, didTapOnTreeItem: cell.treeItem!)
        
        guard let insertselectingItems = cell.treeItem?.childrenItems else { //self.listItemsAtPath(cell.treeItem?.pathForChildren()) else {
            return
        }
        
        var insertTreeItemIndex = self.treeItems.indexOf(cell.treeItem!)!
        var insertIndexPaths = Array<NSIndexPath>()
        
        var removeIndexPaths = Array<NSIndexPath>()
        var treeItemsToRemove = Array<ZXTreeItem>()
        
        for item in insertselectingItems {
            item.path = cell.treeItem?.pathForChildren()
            item.parentItem = cell.treeItem
            
            cell.treeItem?.childrenItems.removeAll()
            cell.treeItem?.childrenItems.appendContentsOf(insertselectingItems)
            
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
        
        self.delegate?.treeView(self, didTapOnTreeItem: cell.treeItem!)
    
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
        
        for var i = 0; i < self.tableView.numberOfRowsInSection(0); ++i {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = self.tableView(self.tableView, cellForRowAtIndexPath: indexPath) as! ZXTreeViewCell
            
            for item in items {
                if cell.treeItem!.isEqualToSelectingItem(item) {
                    result.append(indexPath)
                }
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
    var submersionLevel:Int = 0
    var isDirectory:Bool = false
    
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















