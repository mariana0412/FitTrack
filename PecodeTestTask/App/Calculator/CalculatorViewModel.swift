//
//  CalculatorViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

class CalculatorViewModel {
    
    let calculatorTypesNames = ["Body Mass Index", "Fat Percentage", "Daily Calorie Requirement"]
    
    private var coordinator: CalculatorCoordinator?
    
    init(coordinator: CalculatorCoordinator?) {
        self.coordinator = coordinator
    }
    
}
