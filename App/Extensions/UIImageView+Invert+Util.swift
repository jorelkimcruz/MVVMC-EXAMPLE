//
//  UIImageView+Invert+Util.swift
//  App
//
//  Created by MAC HOME on 11/10/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

extension UIImage {
    func inverted() -> UIImage {
        if let cgImage = self.cgImage, let filter = CIFilter(name: "CIColorInvert")  {
            let image = CIImage(cgImage: cgImage)
            filter.setDefaults()
            filter.setValue(image, forKey: kCIInputImageKey)
            let context = CIContext(options: nil)
            let imageRef = context.createCGImage(filter.outputImage!, from: image.extent)
            return UIImage(cgImage: imageRef!)
        } else {
            return self
        }
    }
}
