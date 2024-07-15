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
            case .registeredWithSex(let registrationData):
                self?.showTabBar(with: registrationData)
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

    private func showTabBar(with registrationData: RegistrationData) {
        tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator?.start()
    }
    
}
