//
//  ProgressCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class ProgressCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let progressViewController = ProgressViewController.instantiate()
        progressViewController.viewModel = ProgressViewModel(coordinator: self)
        navigationController.pushViewController(progressViewController, animated: false)
    }
    
}
