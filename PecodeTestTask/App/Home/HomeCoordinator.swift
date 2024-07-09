//
//  HomeCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class HomeCoordinator: Coordinator {
    var navigationController: UINavigationController
    private var heroName: String

    init(navigationController: UINavigationController, heroName: String) {
        self.navigationController = navigationController
        self.heroName = heroName
    }

    func start() {
        let homeViewController = HomeViewController.instantiate()
        homeViewController.viewModel = HomeViewModel(coordinator: self, 
                                                     heroName: heroName)
        navigationController.pushViewController(homeViewController, animated: false)
    }
}
