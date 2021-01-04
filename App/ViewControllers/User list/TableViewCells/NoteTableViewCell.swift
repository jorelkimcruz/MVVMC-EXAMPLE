//
//  NoteTableViewCell.swift
//  App
//
//  Created by MAC HOME on 11/11/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit
class NoteTableViewCell: StandardTableViewCell {
    
    
    //MARK: CONFIGURE
    override func configure(data user: User, inverted: Bool = false) {
        
        // Remove image on deque
        self.avatarImageView.image = nil
        noteImageView.isHidden = false
        guard let avatar = user.avatarURL, let login = user.login, let detail = user.url else {
            return
        }
        usernameLabel.text = login
        detailsLabel.text = detail.absoluteString
        
        self.avatarImageView.downloadAndCache(url: avatar) { [weak self] (image) in
            guard let `self` = self else {
                return
            }
            if inverted {
                DispatchQueue.global(qos: .default).async {
                    // Create thread for each CIFilter
                    if let originalCIImage = CIImage(image: image), let inverted = originalCIImage.invertFilter() {
                        // Dispatch to main thread after application of filter
                        DispatchQueue.main.async {
                            self.avatarImageView.image = UIImage(ciImage:inverted)
                        }
                    }
                }
            } else {
                  self.avatarImageView.image = image
            }
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

