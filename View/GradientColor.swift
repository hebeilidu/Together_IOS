//
//  GradientColor.swift
//  Together
//
//  Created by Moran Xu on 11/27/21.
//

import Foundation
import UIKit

class GradientColor{
    static func image(fromLayer layer: CALayer) -> UIImage {
        
        UIGraphicsBeginImageContext(layer.frame.size)

        layer.render(in: UIGraphicsGetCurrentContext()!)

        let outputImage = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()

        return outputImage!
    }
    
    
}
