//
//  LoginCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import UIKit

class LoginCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let loginViewController = LoginViewController.instantiate()
        loginViewController.viewModel = LoginViewModel(coordinator: self)
        navigationController.pushViewController(loginViewController, animated: false)
    }
    
    func navigateToSplash() {
        let splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator.start()
    }
    
    func navigateToHome(userSex: UserSex) {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController,
                                                  userSex: userSex)
        tabBarCoordinator.start()
    }
    
    func navigateToSignup() {
        navigationController.popViewController(animated: false)
    }
    
    func navigateToForgotPassword() {
        let forgotPasswordCoordinator = ForgotPasswordCoordinator(navigationController: navigationController)
        forgotPasswordCoordinator.start()
    }
    
}
