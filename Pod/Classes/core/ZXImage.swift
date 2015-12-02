//
//  ZXImage.swift
//  Pods
//
//  Created by user on 15/12/2.
//
//

import Foundation
import UIKit

extension UIImage {
    class func zx_imageNamed(name:String) -> UIImage? {
        
        
        let bundle = NSBundle(forClass: ZXGuideViewController.self)
        print(bundle.bundlePath)
        
        let imgName = "Frameworks/ZXKit.framework/ZXKit.bundle/\(name)"
        return UIImage(named: imgName)
    }
}