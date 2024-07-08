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
    private var heroName: String

    init(navigationController: UINavigationController, heroName: String) {
        self.navigationController = navigationController
        self.tabBarController = TabBarController()
        self.heroName = heroName
    }

    func start() {
        let homeNavController = createNavController(for: .home)
        let progressNavController = createNavController(for: .progress)
        let calculatorNavController = createNavController(for: .calculator)
        let musclesNavController = createNavController(for: .muscles)
        
        tabBarController.setViewControllers([homeNavController, progressNavController, calculatorNavController, musclesNavController], animated: false)

        navigationController.setViewControllers([tabBarController], animated: false)
    }

    private func createNavController(for item: TabBarItem) -> UINavigationController {
        let navController = UINavigationController()

        switch item {
        case .home:
            let homeCoordinator = HomeCoordinator(navigationController: navController, heroName: heroName)
            homeCoordinator.start()

        case .progress:
            let progressCoordinator = ProgressCoordinator(navigationController: navController)
            progressCoordinator.start()

        case .calculator:
            let calculatorCoordinator = CalculatorCoordinator(navigationController: navController)
            calculatorCoordinator.start()

        case .muscles:
            let musclesCoordinator = MusclesCoordinator(navigationController: navController)
            musclesCoordinator.start()
        }
        
        configureTabBarItem(for: navController, with: item)
        
        return navController
    }
    
    private func configureTabBarItem(for viewController: UIViewController, with item: TabBarItem) {
        let tabBarItem = UITabBarItem(title: item.title, image: item.icon?.withRenderingMode(.alwaysOriginal), selectedImage: item.selectedIcon?.withRenderingMode(.alwaysOriginal))
        viewController.tabBarItem = tabBarItem
    }
}
