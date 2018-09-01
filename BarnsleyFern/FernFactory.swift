//
//  FernFactory.swift
//  BarnsleyFern
//
//  Created by Konrad on 01/09/2018.
//  Copyright © 2018 Konrad. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class FernFactory {
    
    class func generate(size: CGSize, transforms: Int, scale: CGFloat = 1) -> UIImage? {
        guard let space = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        
        let width: Int = Int(size.width * scale)
        let height: Int = Int(size.height * scale)
        let _context: CGContext? = CGContext(data: nil,
                                width: width,
                                height: height,
                                bitsPerComponent: 8,
                                bytesPerRow: 0,
                                space: space,
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        guard let context: CGContext = _context else { return nil }
        
        var x0 = 0.0
        var x1 = 0.0
        var y0 = 0.0
        var y1 = 0.0
        
        context.setFillColor(UIColor.black.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        context.setFillColor(UIColor.green.cgColor)
        
        for _ in 0..<transforms {
            switch Int(arc4random()) % 100 {
            case 0:
                x1 = 0
                y1 = 0.16 * y0
            case 1...7:
                x1 = -0.15 * x0 + 0.28 * y0
                y1 = 0.26 * x0 + 0.24 * y0 + 0.44
            case 8...15:
                x1 = 0.2 * x0 - 0.26 * y0
                y1 = 0.23 * x0 + 0.22 * y0 + 1.6
            default:
                x1 = 0.85 * x0 + 0.04 * y0
                y1 = -0.04 * x0 + 0.85 * y0 + 1.6
            }
            
            context.fill(CGRect(x: Double(width / 10) * x1 + Double(width) / 2.0,
                                y: Double(height / 10) * y1,
                                width: 1,
                                height: 1))
            
            (x0, y0) = (x1, y1)
        }
        
        guard let cgImage: CGImage = context.makeImage() else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
