//
//  HomeCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let userSex: UserSex
    
    init(navigationController: UINavigationController, userSex: UserSex) {
        self.navigationController = navigationController
        self.userSex = userSex
    }

    func start() {
        let homeViewController = HomeViewController.instantiate()
        homeViewController.viewModel = HomeViewModel(coordinator: self,
                                                     userSex: userSex)
        navigationController.pushViewController(homeViewController, animated: false)
    }
    
    func navigateToProfile() {
        let profileCoordinator = ProfileCoordinator(navigationController: navigationController)
        profileCoordinator.start()
    }
}
