//
//  HomeCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewController = HomeViewController.instantiate()
        homeViewController.viewModel = HomeViewModel(coordinator: self)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
