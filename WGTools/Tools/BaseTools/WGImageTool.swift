//
//  WGImageTool.swift
//  WGTools
//
//  Created by 窝瓜 on 2021/5/10.
//  Copyright © 2021 土豆小窝瓜. All rights reserved.
//  裁剪图片某个区域

import Foundation
import UIKit

extension UIImage {
    
    // 裁剪图片制定区域
    public func cropImageWithArea(_ areaRect: CGRect) -> UIImage? {
        guard let sourceImageRef = self.cgImage else { return nil }
        // 1.判定是否超出裁剪区域
        let originSize = self.size
        var cropRect = areaRect
        let originScale = areaRect.size.width / areaRect.size.height
        if originSize.width < areaRect.size.width {
            cropRect.size.width = originSize.width
            cropRect.size.height = originSize.width / originScale
        }
        if originSize.height < areaRect.size.height {
            cropRect.size.height = originSize.height
            cropRect.size.width = originSize.height * originScale
        }
        
        // 2.进行裁剪
        guard let cropImageRef = sourceImageRef.cropping(to: cropRect) else { return nil }
        let newImage = UIImage.init(cgImage: cropImageRef, scale: UIScreen.main.scale, orientation: .up)
        return newImage
        var newSize = cropRect.size
        if cropRect.size.width < UIScreen.main.bounds.width-48 {
            // 调整大小
            let newScale = newSize.height / newSize.width
            newSize.width = UIScreen.main.bounds.width-48
            newSize.height = newSize.width*newScale
        } else {
            return newImage
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        newImage.draw(in: CGRect.init(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let bigImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return bigImage
//        return UIImage.init(cgImage: cropImageRef)
        
    }
    
    // 图片方向纠正
    func wg_fixedImageToUpOrientation() -> UIImage {
        guard self.imageOrientation != .up, let cgImage = self.cgImage else {
            return self
        }
        var transform = CGAffineTransform.identity
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: self.size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)//-90.0
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default:
            break
        }
        
        
        let ctx = CGContext.init(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: cgImage.colorSpace!, bitmapInfo: cgImage.bitmapInfo.rawValue)
        
        ctx?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            ctx?.draw(cgImage, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        guard let fiexedCGImage = ctx?.makeImage() else {return self}
        return UIImage(cgImage: fiexedCGImage)
    }
}
