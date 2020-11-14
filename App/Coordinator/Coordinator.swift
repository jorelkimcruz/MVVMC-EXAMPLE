//
//  Coordinator.swift
//  App
//
//  Created by MAC HOME on 11/12/20.
//  Copyright © 2020 JORELCRUZ. All rights reserved.
//

import Foundation
import UIKit

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

class Coordinator: NSObject, CoordinatorProtocol {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
    }
    
    func free(coordinator: Coordinator) {
        childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
}

extension Coordinator: UINavigationControllerDelegate {
    // Free up coordinator child coordinator
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        free(coordinator: self)
    }
}
