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
protocol UsersListViewControllerListener: class {
    func didSelect(user: User)
}
class UsersListViewController: UIViewController, Storyboarded {
    
    weak var delegate: UsersListViewControllerListener?
    
    var userViewModel: UserListViewModel!
    private var dataSource : UserTableViewDataSource!
    @IBOutlet var userTableView: UITableView!
    let connectivityMonitor = NWPathMonitor()
    
    private var isLoading: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Set TableView Settings
        userTableView.separatorStyle = .none
        
        // MARK: Register UITableViewCell
        userTableView.register(LoadingTableViewCell.self, forCellReuseIdentifier: LoadingTableViewCell.identifier())
        userTableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier())
        userTableView.register(InvertedTableViewCell.self, forCellReuseIdentifier: InvertedTableViewCell.identifier())
        userTableView.register(StandardTableViewCell.self, forCellReuseIdentifier: StandardTableViewCell.identifier())
        
        // MARK: Initialize view model
        self.userViewModel = UserListViewModel(service: APIService(), persistence: UserStorageManger(container: CoreDataStorage.shared.persistentContainer))
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
        self.dataSource = UserTableViewDataSource(items: userViewModel.userList)
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
            self.isLoading = false
            // MARK: add datasource
            self.userTableView.dataSource = self.dataSource
            self.userTableView.delegate = self
            self.userTableView.reloadData()
        }
    }
}

extension UsersListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelect(user: userViewModel.userList[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  78
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // MARK: this will turn on `masksToBounds` just before showing the cell
        if indexPath.section == 1 {
            cell.contentView.layer.masksToBounds = true
        }
    }
    
}


extension UsersListViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            if !isLoading {
                isLoading = true
                DispatchQueue.global().async {
                    // Fake background loading task for 1 seconds
                    sleep(2)
                    // Download more data here
                    self.userViewModel.requestUserListFromServer()
                }
            }
        }
        
    }
}

