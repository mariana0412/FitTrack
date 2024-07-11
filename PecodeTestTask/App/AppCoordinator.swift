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
    private var tabBarCoordinator: TabBarCoordinator?
    private var splashCoordinator: SplashCoordinator?

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        checkCurrentUser()
    }
    
    private func checkCurrentUser() {
        if let currentUser = Auth.auth().currentUser {
            print("currentUser id: ", currentUser.uid)
            
            FirebaseService.shared.fetchUserDetails { [weak self] response, registrationData in
                switch response {
                case .success:
                    if let registrationData = registrationData, let sex = registrationData.sex, !sex.isEmpty {
                        self?.showTabBar(with: registrationData)
                    } else {
                        self?.showSplashScreen()
                    }
                case .failure(let error):
                    print("Error fetching user details: \(error.localizedDescription)")
                    self?.showSignupScreen()
                case .unknown:
                    print("Unknown error fetching user details")
                    self?.showSignupScreen()
                }
            }
        } else {
            showSignupScreen()
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
