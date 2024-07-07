//
//  SplashCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.07.2024.
//

import UIKit

class SplashCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let splashViewController = SplashViewController.instantiate() else {
            fatalError("Unable to instantiate SplashViewController from storyboard")
        }
        navigationController.pushViewController(splashViewController, animated: true)
    }
}
