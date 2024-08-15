//
//  CalculatorCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//

import UIKit

class CalculatorCoordinator: Coordinator {
    var navigationController: UINavigationController
    let type: CalculatorType
    
    init(navigationController: UINavigationController, type: CalculatorType) {
        self.navigationController = navigationController
        self.type = type
    }
    
    func start() {
        let calculatorViewController = CalculatorViewController.instantiate()
        calculatorViewController.viewModel = CalculatorViewModel(coordinator: self, type: type)
        calculatorViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(calculatorViewController, animated: false)
    }
    
    func navigateToCalculatorSelection() {
        navigationController.popViewController(animated: false)
    }
    
}
