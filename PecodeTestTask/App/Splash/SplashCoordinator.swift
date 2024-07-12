//
//  SplashCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.07.2024.
//

import UIKit

class SplashCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let splashViewController = SplashViewController.instantiate()
        splashViewController.viewModel = SplashViewModel(coordinator: self)
        navigationController.pushViewController(splashViewController, animated: false)
    }
    
    func navigateToHome() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.start()
    }
    
}
