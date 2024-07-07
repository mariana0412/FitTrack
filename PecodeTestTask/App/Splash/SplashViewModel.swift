//
//  SplashViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 07.07.2024.
//

class SplashViewModel {
    private var coordinator: SplashCoordinator?
    
    init(coordinator: SplashCoordinator?) {
        self.coordinator = coordinator
    }
    
    func buttonTapped(with heroName: String) {
        coordinator?.navigateToHome(with: heroName)
    }
}
