//
//  MusclesCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class MusclesCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let musclesViewController = MusclesViewController.instantiate()
        musclesViewController.viewModel = MusclesViewModel(coordinator: self)
        navigationController.pushViewController(musclesViewController, animated: false)
    }
    
}
