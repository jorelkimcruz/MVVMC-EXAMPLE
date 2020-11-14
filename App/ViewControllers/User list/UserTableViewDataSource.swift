//
//  UserTableViewDataSource.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//
import Foundation
import UIKit

typealias StandardCell = TableCellConfigurator<StandardTableViewCell, User>
typealias NoteCell = TableCellConfigurator<NoteTableViewCell, User>
typealias InvertedCell = TableCellConfigurator<InvertedTableViewCell, User>


class UserTableViewDataSource : NSObject, UITableViewDataSource {
    
    private var cells : [CellConfigurator] = []
    
    init(items : [User]) {
        for item in items.enumerated() {
            if item.offset % 4 == 3 {
                if let itemNote = item.element.note, !itemNote.isEmpty {
                    cells.append(NoteCell(item: item.element, inverted: true))
                } else {
                    cells.append(InvertedCell(item: item.element))
                }
            } else {
                if let itemNote = item.element.note, !itemNote.isEmpty {
                    log_success(message: "NOTE CELL")
                    cells.append(NoteCell(item: item.element))
                } else {
                    cells.append(StandardCell(item: item.element))
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cells.count > 0 ? tableView.restore() :  tableView.setEmptyView()
        return section == 1 ? 1 : cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let item = cells[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: type(of: item).reuseId)!
            item.configure(cell: cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: LoadingTableViewCell.identifier(), for: indexPath) as! LoadingTableViewCell
            cell.loadingIndicator.startAnimating()
            return cell
        }
        
    }
    
}


