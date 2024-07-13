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
    
}
