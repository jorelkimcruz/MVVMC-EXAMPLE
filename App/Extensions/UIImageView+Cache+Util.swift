//
//  UIImage+Cache+Util.swift
//  App
//
//  Created by MAC HOME on 11/10/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

let imageDataCache = NSCache<AnyObject, UIImage>()

extension UIImageView {
    
    func downloadAndCacheImage(url: URL, invert: Bool) {
        self.image = nil
        
        if let cachedImage = imageDataCache.object(forKey: url.absoluteString as AnyObject) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let `error` = error {
                log_error(message: error.localizedDescription)
                return
            } else {
                log_success(message: response.debugDescription)
                DispatchQueue.global(qos: .background).sync {
                    if let `data` = data, let downloadedImage = UIImage(data: data) {
                        imageDataCache.setObject(invert ? downloadedImage.inverted() : downloadedImage, forKey: url.absoluteString as AnyObject)
                    }
                }
                DispatchQueue.main.async {
                    if let cachedImage = imageDataCache.object(forKey: url.absoluteString as AnyObject) {
                        self.image = cachedImage
                        return
                    }
                }
            }
        }.resume()
    }
}
