//
//  ChartCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

import UIKit

class ChartCoordinator: Coordinator {
    var navigationController: UINavigationController
    let optionData: OptionData
    
    init(navigationController: UINavigationController, optionData: OptionData) {
        self.navigationController = navigationController
        self.optionData = optionData
    }
    
    func start() {
        let chartViewController = ChartViewController.instantiate()
        chartViewController.viewModel = ChartViewModel(coordinator: self, 
                                                       optionData: optionData)
        chartViewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(chartViewController, animated: false)
    }
    
    func navigateToProgress() {
        navigationController.popViewController(animated: false)
    }
    
}
