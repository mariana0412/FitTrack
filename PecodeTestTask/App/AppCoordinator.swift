//
//  AppCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit
import FirebaseAuth

class AppCoordinator: Coordinator {
    private let window: UIWindow
    var navigationController: UINavigationController
    private var signupCoordinator: SignupCoordinator?
    private var loginCoordinator: LoginCoordinator?
    private var tabBarCoordinator: TabBarCoordinator?
    private var splashCoordinator: SplashCoordinator?
    

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        let userOptions: [OptionData] = [
            OptionData(optionName: OptionDataName.height, value: 170, isShown: true),
            OptionData(optionName: OptionDataName.weight, value: 50, isShown: true),
            OptionData(optionName: OptionDataName.neck, value: 10, isShown: true)
        ]

        // for testing purposes
//        do {
//            try Auth.auth().signOut()
//        } catch {}
        
        checkCurrentUser()
    }
    
    private func checkCurrentUser() {
        FirebaseService.shared.checkCurrentUser { [weak self] userStatus in
            switch userStatus {
            case .unregistered:
                self?.showSignupScreen()
            case .registeredWithoutSex:
                self?.showSplashScreen()
            case .registeredWithSex(let sex):
                self?.showTabBar(userSex: sex)
            }
        }
    }

    private func showSignupScreen() {
        signupCoordinator = SignupCoordinator(navigationController: navigationController)
        signupCoordinator?.start()
    }

    private func showSplashScreen() {
        splashCoordinator = SplashCoordinator(navigationController: navigationController)
        splashCoordinator?.start()
    }

    private func showTabBar(userSex: UserSex) {
        tabBarCoordinator = TabBarCoordinator(navigationController: navigationController,
                                              userSex: userSex)
        tabBarCoordinator?.start()
    }
    
}
