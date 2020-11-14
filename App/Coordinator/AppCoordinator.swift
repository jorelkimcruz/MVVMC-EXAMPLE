//
//  AppCoordinator.swift
//  App
//
//  Created by MAC HOME on 11/12/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import UIKit

class MainCoordinator: Coordinator {
    
    override func start() {
        let viewController = UsersListViewController.instantiate(name: .main)
        viewController.delegate = self
        self.navigationController.pushViewController(viewController, animated: false)
    }
    
    func presentProfileScreen(user: User) {
        let vc = UserProfileViewController.instantiate(name: .main)
        vc.profileViewModel = ProfileViewModel(user: user, service: APIService(), persistence: UserStorageManger(container: CoreDataStorage.shared.persistentContainer))
        vc.delegate = self
        navigationController.pushViewController(vc, animated: true)
    }
    
}
extension MainCoordinator: UserProfileViewControllerListener {
    func userDidUpdate(user: User) {
        if let rootcontroller = self.navigationController.viewControllers.first,
            rootcontroller is UsersListViewController,
            let controller = rootcontroller as? UsersListViewController {
            controller.userViewModel.getUserListFromPersistence()
        }
    }
}

extension MainCoordinator: UsersListViewControllerListener {
    func didSelect(user: User) {
        presentProfileScreen(user: user)
    }
}
