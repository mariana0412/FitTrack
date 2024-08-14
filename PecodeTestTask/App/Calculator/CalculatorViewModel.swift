//
//  CalculatorViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//


class CalculatorViewModel {
    
    let navigationBarTitle = "Calculator"

    private var coordinator: CalculatorCoordinator?
    let type: CalculatorType
    
    init(coordinator: CalculatorCoordinator?, type: CalculatorType) {
        self.coordinator = coordinator
        self.type = type
    }
    
    func navigateToCalculatorSelection() {
        coordinator?.navigateToCalculatorSelection()
    }
    
}
