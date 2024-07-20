//
//  EditProfileCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let profileViewController = ProfileViewController.instantiate()
        profileViewController.viewModel = ProfileViewModel(coordinator: self)
        profileViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(profileViewController, animated: false)
    }
    
    func navigateToHome() {
        navigationController.popViewController(animated: false)
    }
    
}
