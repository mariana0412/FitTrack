//
//  HomeCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let homeViewController = HomeViewController.instantiate() else {
            fatalError("Unable to instantiate HomeViewController from storyboard")
        }
        homeViewController.viewModel = HomeViewModel(coordinator: self)
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
