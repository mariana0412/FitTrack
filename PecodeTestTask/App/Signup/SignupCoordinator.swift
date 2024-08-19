//
//  SignUpCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import UIKit

class SignupCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let signupViewController = SignupViewController.instantiate()
        signupViewController.viewModel = SignupViewModel(coordinator: self)
        navigationController.pushViewController(signupViewController, animated: false)
    }
    
    func navigateToSplash() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator.start()
    }
    
    func navigateToLogin() {
        let loginCoordinator = LoginCoordinator(navigationController: navigationController)
        loginCoordinator.start()
    }
    
    func navigateToAlert(alertContent: AlertContent) {
        let alertCoordinator = AlertCoordinator(navigationController: navigationController, alertContent: alertContent)
        alertCoordinator.start()
    }
    
}
