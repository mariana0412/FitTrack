//
//  CalculatorViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

class CalculatorSelectionViewModel {
    
    let navigationItemTitle = "Calculator"
    let calculatorTypesNames = ["Body Mass Index", "Fat Percentage", "Daily Calorie Requirement"]
    
    private var coordinator: CalculatorSelectionCoordinator?
    
    init(coordinator: CalculatorSelectionCoordinator?) {
        self.coordinator = coordinator
    }
    
}
