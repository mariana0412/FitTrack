//
//  SceneDelegate.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
            
        configureWindow(with: windowScene)
    }

    private func configureWindow(with windowScene: UIWindowScene) {
        let window = UIWindow(windowScene: windowScene)
        self.window = window

        let appCoordinator = AppCoordinator(window: window)
        self.appCoordinator = appCoordinator
        appCoordinator.start()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
    
}

