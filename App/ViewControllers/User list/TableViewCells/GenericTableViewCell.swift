//
//  GenericTableViewCell.swift
//  App
//
//  Created by MAC HOME on 11/11/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype DataType
    func configure(data: DataType, inverted: Bool)
    
    var avatarImageView: UIImageView { get }
    var usernameLabel: UILabel { get }
    var detailsLabel: UILabel { get }
}

protocol CellConfigurator {
    static var reuseId: String { get }
    func configure(cell: UIView)
}

class TableCellConfigurator<CellType: ConfigurableCell, DataType>: CellConfigurator where CellType.DataType == DataType, CellType: UITableViewCell {
    static var reuseId: String { return String(describing: CellType.self) }
    
    let item: DataType
    var inverted: Bool = false

    init(item: DataType, inverted: Bool = false) {
        self.item = item
        self.inverted = inverted
    }

    func configure(cell: UIView) {
        (cell as! CellType).configure(data: item, inverted: inverted)
    }
}
