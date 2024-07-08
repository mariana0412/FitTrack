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
        guard let splashViewController = SplashViewController.instantiate() else {
            fatalError("Unable to instantiate SplashViewController from storyboard")
        }
        splashViewController.viewModel = SplashViewModel(coordinator: self)
        navigationController.pushViewController(splashViewController, animated: false)
    }
    
    func navigateToHome(with heroName: String) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController, heroName: heroName)
        tabBarCoordinator.start()
    }
    
}
