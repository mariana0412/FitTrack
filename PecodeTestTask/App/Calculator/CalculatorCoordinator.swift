//
//  CalculatorCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class CalculatorCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let calculatorViewController = CalculatorViewController.instantiate()
        calculatorViewController.viewModel = CalculatorViewModel(coordinator: self)
        navigationController.pushViewController(calculatorViewController, animated: false)
    }
    
}
