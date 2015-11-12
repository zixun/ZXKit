//
//  ZXDef.swift
//  CocoaChinaPlus
//
//  Created by 子循 on 15/6/18.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

func ZXScreenWidth() -> CGFloat {
    return UIScreen.mainScreen().bounds.size.width
}

func ZXScreenHight() -> CGFloat {
    return UIScreen.mainScreen().bounds.size.height
}

//Mark: print相关
func println(items: Any...){    
    print(items, terminator: "\n")
}

func alert(message:String) {
    UIAlertView(title: "提示", message: message, delegate: nil, cancelButtonTitle: "取消").show()
}

//option链相关
func judge(string:String?) ->String {
    return string != nil ? string! : ""
}