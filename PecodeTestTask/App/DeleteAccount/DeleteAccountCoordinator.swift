//
//  DeleteAccountCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

import UIKit

class DeleteAccountCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let deleteAccountViewController = DeleteAccountViewController.instantiate()
        deleteAccountViewController.viewModel = DeleteAccountViewModel(coordinator: self)
        navigationController.pushViewController(deleteAccountViewController, animated: false)
    }
    
}
