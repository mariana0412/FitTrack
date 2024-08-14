//
//  CalculatorViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

class CalculatorSelectionViewModel {
    
    let navigationItemTitle = "Calculator"
    let calculatorTypes: [CalculatorType] = CalculatorType.allCases
    
    private var coordinator: CalculatorSelectionCoordinator?
    
    init(coordinator: CalculatorSelectionCoordinator?) {
        self.coordinator = coordinator
    }
    
    func navigateToCalculator(type: CalculatorType) {
        coordinator?.navigateToCalculator(type: type)
    }
    
}
