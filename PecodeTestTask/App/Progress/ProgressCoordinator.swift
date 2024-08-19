//
//  ProgressCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class ProgressCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let userSex: UserSex
    
    init(navigationController: UINavigationController, userSex: UserSex) {
        self.navigationController = navigationController
        self.userSex = userSex
    }
    
    func start() {
        let progressViewController = ProgressViewController.instantiate()
        progressViewController.viewModel = ProgressViewModel(coordinator: self,
                                                             userSex: userSex)
        navigationController.pushViewController(progressViewController, animated: false)
    }
    
    func navigateToChart(optionData: OptionData) {
        let chartCoordinator = ChartCoordinator(navigationController: navigationController, optionData: optionData)
        chartCoordinator.start()
    }
    
}
