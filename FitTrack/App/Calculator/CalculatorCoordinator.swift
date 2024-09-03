//
//  CalculatorCoordinator.swift
//  FitTrack
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
    
    func navigateToActivityLevel(selectedActivityLevel: DailyCaloriesRateActivity?) {
        let activityLevelCoordinator = ActivityLevelCoordinator(navigationController: navigationController,
                                                                selectedActivityLevel: selectedActivityLevel)
        activityLevelCoordinator.delegate = self
        activityLevelCoordinator.start()
    }
    
}

extension CalculatorCoordinator: ActivityLevelCoordinatorDelegate {
    func didSelectActivityLevel(_ activityLevel: DailyCaloriesRateActivity?) {
        if let calculatorVC = navigationController.topViewController as? CalculatorViewController {
            calculatorVC.selectedActivityLevel = activityLevel
        }
    }
}
