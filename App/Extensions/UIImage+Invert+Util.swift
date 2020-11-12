//
//  UIImageView+Invert+Util.swift
//  App
//
//  Created by MAC HOME on 11/10/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

extension CIImage {
    func invertFilter() -> CIImage? {
        let sepiaFilter = CIFilter(name:"CIColorInvert")
        sepiaFilter?.setValue(self, forKey: kCIInputImageKey)
        return sepiaFilter?.outputImage
    }
}
