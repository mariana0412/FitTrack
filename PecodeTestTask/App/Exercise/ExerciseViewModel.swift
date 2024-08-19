//
//  ExerciseViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

class ExerciseViewModel {
    
    let navigationItemTitle = "Exercise"
    let showMoreButtonTitle = "...showMore"
    
    private var coordinator: ExerciseCoordinator?
    let exercise: Exercise
    
    init(coordinator: ExerciseCoordinator?, exercise: Exercise) {
        self.coordinator = coordinator
        self.exercise = exercise
    }
    
    func navigateToMuscles() {
        coordinator?.navigateToMuscles()
    }
    
}
