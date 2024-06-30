//
//  AppCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    private let window: UIWindow
    private let navigationController: UINavigationController
    private var homeCoordinator: HomeCoordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator?.start()
    }
}
