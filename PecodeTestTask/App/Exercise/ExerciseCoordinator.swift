//
//  ExerciseCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

class ExerciseCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let exercise: Exercise
    
    init(navigationController: UINavigationController, exercise: Exercise) {
        self.navigationController = navigationController
        self.exercise = exercise
    }
    
    func start() {
        let exerciseViewController = ExerciseViewController.instantiate()
        exerciseViewController.viewModel = ExerciseViewModel(coordinator: self, 
                                                             exercise: exercise)
        navigationController.pushViewController(exerciseViewController, animated: false)
    }
    
    func navigateToMuscles() {
        navigationController.popViewController(animated: false)
    }
    
}
