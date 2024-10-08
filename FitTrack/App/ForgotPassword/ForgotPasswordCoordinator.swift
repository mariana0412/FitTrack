//
//  ForgotPasswordCoordinator.swift
//  FitTrack
//
//  Created by Mariana Piz on 17.07.2024.
//

import UIKit

class ForgotPasswordCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let forgotPasswordViewController = ForgotPasswordViewController.instantiate()
        forgotPasswordViewController.viewModel = ForgotPasswordViewModel(coordinator: self)
        navigationController.pushViewController(forgotPasswordViewController, animated: false)
    }
    
    func navigateToLogin() {
        navigationController.popViewController(animated: false)
    }
    
    func navigateToAlert(alertContent: AlertContent) {
        let alertCoordinator = AlertCoordinator(navigationController: navigationController, alertContent: alertContent)
        alertCoordinator.start()
    }
    
}
