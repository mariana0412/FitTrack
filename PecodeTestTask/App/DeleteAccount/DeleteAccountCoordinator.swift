//
//  DeleteAccountCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

import UIKit

class DeleteAccountCoordinator: Coordinator {
    var navigationController: UINavigationController
    let userSex: UserSex
    
    init(navigationController: UINavigationController, userSex: UserSex) {
        self.navigationController = navigationController
        self.userSex = userSex
    }
    
    func start() {
        let deleteAccountViewController = DeleteAccountViewController.instantiate()
        deleteAccountViewController.viewModel = DeleteAccountViewModel(coordinator: self,
                                                                       userSex: userSex)
        navigationController.pushViewController(deleteAccountViewController, animated: false)
    }
    
    func navigateToProfile() {
        navigationController.popViewController(animated: false)
    }
    
}
