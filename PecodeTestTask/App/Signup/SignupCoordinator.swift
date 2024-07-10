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
    
}
