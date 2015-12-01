//
//  Array+.swift
//  ZXKit
//
//  Created by user on 15/12/1.
//  Copyright © 2015年 陈奕龙. All rights reserved.
//

import Foundation

extension RangeReplaceableCollectionType where Generator.Element : Equatable {
    
    // Remove first collection element that is equal to the given `object`:
    mutating func removeObject(object : Generator.Element) {
        if let index = self.indexOf(object) {
            self.removeAtIndex(index)
        }
    }
}

extension Array where Element : Equatable {
    
    // ... same method as above ...
}