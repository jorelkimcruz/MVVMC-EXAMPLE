//
//  loadingTableViewCell.swift
//  App
//
//  Created by MAC HOME on 11/12/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

class LoadingTableViewCell: UITableViewCell {
    lazy var loadingIndicator: UIActivityIndicatorView = {
        // UIActivityIndicatorView Settings
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.color = self.traitCollection.userInterfaceStyle == .dark ? .white : .black
        return indicator
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        
        // add corner radius on `contentView`
        contentView.backgroundColor = .clear
        
        // MARK: Add ui to contentView
        contentView.addSubview(loadingIndicator)
        // MARK: Activate custom constraints
        NSLayoutConstraint.activate([
            
            // loadingIndicator
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0),
            
        ])
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
