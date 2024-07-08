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
        guard let calculatorViewController = CalculatorViewController.instantiate() else {
            fatalError("Unable to instantiate CalculatorViewController from storyboard")
        }
        calculatorViewController.viewModel = CalculatorViewModel(coordinator: self)
        navigationController.pushViewController(calculatorViewController, animated: false)
    }
    
}
