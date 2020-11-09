//
//  UITableView+Util.swift
//  App
//
//  Created by MAC HOME on 11/7/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit
extension UITableView {
    func setEmptyView() {
        let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height))
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "EMPTY LIST"
        emptyView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor, constant: 0),
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor, constant: 0)
        ])
        self.backgroundView = emptyView
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
