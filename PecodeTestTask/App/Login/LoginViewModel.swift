//
//  LoginViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import FirebaseAuth

class LoginViewModel {
    private var coordinator: LoginCoordinator?
    
    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }

    func loginUser(with loginData: LoginData, completion: @escaping (String?) -> Void) {
        FirebaseService.shared.loginUser(with: loginData) { [weak self] response, registrationData in
            switch response {
            case .success:
                if let user = registrationData {
                    self?.handleNavigation(user: user)
                    completion(nil)
                } else {
                    completion("Failed to fetch user details")
                }
            case .failure(let error):
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred.")
            }
        }
    }
    
    private func handleNavigation(user: RegistrationData) {
        if let sex = user.sex, !sex.isEmpty {
            navigateToHome()
        } else {
            navigateToSplash()
        }
    }

    private func navigateToSplash() {
        coordinator?.navigateToSplash()
    }
    
    private func navigateToHome() {
        coordinator?.navigateToHome()
    }
}
