//
//  SignUpViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

class SignupViewModel {
    private var coordinator: SignupCoordinator?
    
    init(coordinator: SignupCoordinator?) {
        self.coordinator = coordinator
    }
    
    func navigateToSplash() {
        coordinator?.navigateToSplash()
    }
}
