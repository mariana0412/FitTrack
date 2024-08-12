//
//  ExerciseViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

class ExerciseViewModel {
    private var coordinator: ExerciseCoordinator?
    private let exercise: Exercise
    
    init(coordinator: ExerciseCoordinator?, exercise: Exercise) {
        self.coordinator = coordinator
        self.exercise = exercise
    }
    
}
