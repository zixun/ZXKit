//
//  UIImage+Circle.swift
//  CocoaChinaPlus
//
//  Created by user on 15/11/9.
//  Copyright © 2015年 zixun. All rights reserved.
//

import Foundation
import UIKit

// MARK: - draw image
public extension UIImage {
    
    /**
     用CGContextRef代码生成一个UIImage图片对象
     
     - parameter size:         图片大小
     - parameter drawingBlock: 绘画block
     
     - returns: 生成的图片
     */
    public class func image(size: CGSize, drawingBlock:(CGContextRef,CGRect) -> Void) -> UIImage? {
        guard CGSizeEqualToSize(size, CGSizeZero) == false else {
            return nil
        }
        
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextClearRect(context, rect)
        
        drawingBlock(context,rect)
        
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return image;
    }
    
    /**
     生成一个单一颜色的UIImage图片对象
     
     - parameter color:  颜色
     - parameter size:  大小
     
     - returns: 生成的图片对象
     */
    public class func image(color:UIColor, size:CGSize) ->UIImage? {
        
        guard CGSizeEqualToSize(size, CGSizeZero) == false else {
            return nil
        }
        
        let target = UIImage.image(size, drawingBlock: { (context, rect) -> Void in
            CGContextSetFillColorWithColor(context, color.CGColor);
            CGContextFillRect(context, rect);
        })
        return target
    }
}

// MARK: - circle image
public extension UIImage {
    
    public func circleImage() -> UIImage{
        UIGraphicsBeginImageContext(self.size)
        let context = UIGraphicsGetCurrentContext()
        //圆的边框宽度为2，颜色为红色
        
        CGContextSetLineWidth(context,0);
        
        CGContextSetStrokeColorWithColor(context, UIColor.clearColor().CGColor);
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        
        CGContextAddEllipseInRect(context, rect);
        
        CGContextClip(context);
        
        //在圆区域内画出image原图
        self.drawInRect(rect)
        
        CGContextAddEllipseInRect(context, rect);
        
        CGContextStrokePath(context);
        
        //生成新的image
        
        let newimg = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return newimg;
        
    }
}

// MARK: - clip image
public extension UIImage {
    
    /**
     裁剪出图片指定rect区域的内容
     
     - parameter rect: rect区域
     
     - returns: 裁剪后的图片对象
     */
    public func clipImageByRect(rect:CGRect) -> UIImage {
        let subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
        guard subImageRef != nil else {
            return self
        }
        let smallImage = UIImage(CGImage: subImageRef!)
        return smallImage
    }
    
    
    /**
     裁剪出图片指定Edge的内容
     
     - parameter edge: Edge值
     
     - returns: 裁剪后的图片对象
     */
    public func clipImageByEdge(edge:Int) -> UIImage {
        let height = CGImageGetHeight(self.CGImage) - edge * 2
        let width = CGImageGetWidth(self.CGImage) - edge * 2
        let rect = CGRect(x: edge, y: edge, width: width, height: height)
        
        let image = self.clipImageByRect(rect)
        return image
    }
}
