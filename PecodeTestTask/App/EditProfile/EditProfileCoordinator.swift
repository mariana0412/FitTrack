//
//  EditProfileCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class EditProfileCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let editProfileController = EditProfileController.instantiate()
        editProfileController.viewModel = EditProfileViewModel(coordinator: self)
        navigationController.pushViewController(editProfileController, animated: false)
    }
    
}
