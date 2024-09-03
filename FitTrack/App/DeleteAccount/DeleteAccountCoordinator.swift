//
//  DeleteAccountCoordinator.swift
//  FitTrack
//
//  Created by Mariana Piz on 03.08.2024.
//

import UIKit

class DeleteAccountCoordinator: Coordinator {
    var navigationController: UINavigationController
    let userSex: UserSex
    
    init(navigationController: UINavigationController, userSex: UserSex) {
        self.navigationController = navigationController
        self.userSex = userSex
    }
    
    func start() {
        let deleteAccountViewController = DeleteAccountViewController.instantiate()
        deleteAccountViewController.viewModel = DeleteAccountViewModel(coordinator: self,
                                                                       userSex: userSex)
        navigationController.pushViewController(deleteAccountViewController, animated: false)
    }
    
    func navigateToProfile() {
        navigationController.popViewController(animated: false)
    }
    
    func navigateToAlert(alertContent: AlertContent) {
        let alertCoordinator = AlertCoordinator(navigationController: navigationController, 
                                                alertContent: alertContent)
        alertCoordinator.start()
    }
    
    func navigateToSignup() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            let newWindow = UIWindow(windowScene: windowScene)
            let newNavigationController = UINavigationController()
            let signupCoordinator = SignupCoordinator(navigationController: newNavigationController)
            signupCoordinator.start()
            
            newWindow.rootViewController = newNavigationController
            newWindow.makeKeyAndVisible()
            
            if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window = newWindow
            }
        }
    }
    
    func navigateToLogin() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
            
            let newWindow = UIWindow(windowScene: windowScene)
            let newNavigationController = UINavigationController()
            let loginCoordinator = LoginCoordinator(navigationController: newNavigationController)
            loginCoordinator.start()
            
            newWindow.rootViewController = newNavigationController
            newWindow.makeKeyAndVisible()
            
            if let sceneDelegate = windowScene.delegate as? SceneDelegate {
                sceneDelegate.window = newWindow
            }
        }
    }
}
