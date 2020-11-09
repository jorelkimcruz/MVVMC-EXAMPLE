//
//  UsersListViewController.swift
//  App
//
//  Created by MAC HOME on 11/5/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
import UIKit
import Network

class UsersListViewController: UIViewController {
    
    private var userViewModel: UserViewModel!
    private var dataSource : UserTableViewDataSource<UserTableViewCell, User>!
    @IBOutlet var userTableView: UITableView!
    let connectivityMonitor = NWPathMonitor()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Set TableView Settings
        userTableView.separatorStyle = .none
        
        // MARK: Register UITableViewCell
        userTableView.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        
        // MARK: Initialize view model
        self.userViewModel = UserViewModel(service: APIService(), persistence: UserStorageManger(container: CoreDataStorage.shared.persistentContainer))
        self.userViewModel.delegate = self
        
        // Get data on first load
        getData(withState: connectivityMonitor.state())
        
        // Get data when connectivity changes
        connectivityMonitor.stateDidChange { [weak self] (state) in
            guard let `self` = self else {
                return
            }
            self.getData(withState: state)
        }
        
    }
    
    private func getData(withState state: ConnectionState) {
        DispatchQueue.global(qos: .background).async {
            if state == .isActive {
                self.userViewModel.requestUserListFromServer()
            } else {
                self.userViewModel.getUserListFromPersistence()
            }
        }
    }
    
    func renderList() {
        self.dataSource = UserTableViewDataSource(cellIdentifier: UserTableViewCell.identifier, items: self.userViewModel.userList, configureCell: { [weak self] (cell, userdetails, row) in
            guard let _ = self else {
                return
            }
            cell.usernameLabel.text = userdetails.login
            
            if let avatarURL = userdetails.avatarURL {
                cell.avatarImageView.downloadAndCacheImage(url: avatarURL, invert: row % 4 == 3)
            }
            
            if let userURL = userdetails.url {
                cell.detailsLabel.text = String(describing: userURL)
            }
            
        })
        
    }
    
}

extension UsersListViewController: UserViewModelDelegate {
    
    func userDataDidChange() {
        self.userViewModel.syncUserListToPersistence(data: self.userViewModel.userData)
    }
    
    func syncToPersistenDidFinish() {
        // Add after sync actions here
        self.userViewModel.getUserListFromPersistence()
    }
    
    func syncFromPersistenceDidFinish() {
        self.renderList()
        // Reload data on main thread
        DispatchQueue.main.async {
            // MARK: add datasource
            self.userTableView.dataSource = self.dataSource
            self.userTableView.delegate = self
            self.userTableView.reloadData()
        }
    }
}

extension UsersListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 78
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // MARK: this will turn on `masksToBounds` just before showing the cell
        cell.contentView.layer.masksToBounds = true
    }
    
}
