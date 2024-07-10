//
//  AppCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class AppCoordinator: Coordinator {
    private let window: UIWindow
    var navigationController: UINavigationController
    private var signupCoordinator: SignupCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        signupCoordinator = SignupCoordinator(navigationController: navigationController)
        signupCoordinator?.start()
    }

}
