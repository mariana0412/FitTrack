//
//  CalculatorCoordinator.swift
//  FitTrack
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class CalculatorSelectionCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let calculatorSelectionViewController = CalculatorSelectionViewController.instantiate()
        calculatorSelectionViewController.viewModel = CalculatorSelectionViewModel(coordinator: self)
        navigationController.pushViewController(calculatorSelectionViewController, animated: false)
    }
    
    func navigateToCalculator(type: CalculatorType) {
        let calculatorCoordinator = CalculatorCoordinator(navigationController: navigationController,
                                                          type: type)
        calculatorCoordinator.start()
    }
    
}
