//
//  SplashCoordinator.swift
//  FitTrack
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
    
    func navigateToHome(userSex: UserSex) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController,
                                                  userSex: userSex)
        tabBarCoordinator.start()
    }
    
    func navigateToAlert(alertContent: AlertContent) {
        let alertCoordinator = AlertCoordinator(navigationController: navigationController, alertContent: alertContent)
        alertCoordinator.start()
    }
    
}
