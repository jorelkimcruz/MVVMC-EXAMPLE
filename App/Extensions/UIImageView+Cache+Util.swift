//
//  UIImage+Cache+Util.swift
//  App
//
//  Created by MAC HOME on 11/10/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func downloadAndCache(url: URL, downloadComplete: @escaping (UIImage) -> ()) {
        
        DispatchQueue.global(qos: .background).sync {
            if let cachedImage = imageDataCache.object(forKey: url.absoluteString as AnyObject) {
                DispatchQueue.main.async {
                    downloadComplete(cachedImage)
                }
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                if let `error` = error {
                    log_error(message: error.localizedDescription)
                    return
                } else {
                    log_success(message: response.debugDescription)
                    
                    DispatchQueue.global(qos: .utility).sync {
                        if let `data` = data, let downloadedImage = UIImage(data: data) {
                            imageDataCache.setObject(downloadedImage, forKey: url.absoluteString as AnyObject)
                            DispatchQueue.main.async {
                                downloadComplete(downloadedImage)
                            }
                        }
                    }
                    
                }
            }.resume()
        }
    }
    
}
