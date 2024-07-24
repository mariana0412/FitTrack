//
//  TabBarCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class TabBarCoordinator: Coordinator {
    var navigationController: UINavigationController
    private let tabBarController: TabBarController
    private let userSex: UserSex

    init(navigationController: UINavigationController, userSex: UserSex) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
        self.userSex = userSex
    }

    func start() {
        let homeNavController = createNavigationController(for: .home)
        let progressNavController = createNavigationController(for: .progress)
        let calculatorNavController = createNavigationController(for: .calculator)
        let musclesNavController = createNavigationController(for: .muscles)
        
        tabBarController.setViewControllers([homeNavController, 
                                             progressNavController,
                                             calculatorNavController,
                                             musclesNavController],
                                            animated: false)

        navigationController.setViewControllers([tabBarController], animated: false)
    }

    private func createNavigationController(for item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()

        switch item {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navigationController,
                                                  userSex: userSex)
            homeCoordinator.start()

        case .progress:
            let progressCoordinator = ProgressCoordinator(navigationController: navigationController)
            
            progressCoordinator.start()

        case .calculator:
            let calculatorCoordinator = CalculatorCoordinator(navigationController: navigationController)
            
            calculatorCoordinator.start()

        case .muscles:
            let musclesCoordinator = MusclesCoordinator(navigationController: navigationController)
            
            musclesCoordinator.start()
        }
        
        configureTabBarItem(for: navigationController, with: item)
        
        return navigationController
    }
    
    private func configureTabBarItem(for viewController: UIViewController, with item: TabBarItem) {
        let tabBarItem = UITabBarItem(title: item.title, 
                                      image: item.icon?.withRenderingMode(.alwaysOriginal),
                                      selectedImage: item.selectedIcon?.withRenderingMode(.alwaysOriginal))
        viewController.tabBarItem = tabBarItem
    }
}
