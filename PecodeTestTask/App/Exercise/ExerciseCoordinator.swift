//
//  ExerciseCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

class ExerciseCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let exerciseViewController = ExerciseViewController.instantiate()
        exerciseViewController.viewModel = ExerciseViewModel(coordinator: self)
        navigationController.pushViewController(exerciseViewController, animated: false)
    }
    
}
