//
//  ProfileCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class ProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    var user: UserData
    
    init(navigationController: UINavigationController, user: UserData) {
        self.navigationController = navigationController
        self.user = user
    }
    
    func start() {
        let profileViewController = ProfileViewController.instantiate()
        profileViewController.viewModel = ProfileViewModel(coordinator: self,
                                                           user: user)
        profileViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(profileViewController, animated: false)
    }
    
    func navigateToHome() {
        navigationController.popViewController(animated: false)
    }
    
    func navigateToAlert(alertContent: AlertContent) {
        let alertCoordinator = AlertCoordinator(navigationController: navigationController, alertContent: alertContent)
        alertCoordinator.start()
    }
    
}
