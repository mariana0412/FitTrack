//
//  LoginViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import FirebaseAuth

class LoginViewModel {
    private var coordinator: LoginCoordinator?
    
    let superheroText = "SUPERHERO"
    let loginToYourAccountText = "Login to your account"
    let emailText = "Email"
    let emailPlaceholderText = "Enter email"
    let passwordText = "Password"
    let passwordPlaceholderText = "Enter password"
    let forgotPasswordText = "Forgot Password?"
    let loginButtonText = "Login"

    init(coordinator: LoginCoordinator?) {
        self.coordinator = coordinator
    }

    func loginUser(with loginData: LoginData, completion: @escaping (String?) -> Void) {
        FirebaseService.shared.loginUser(with: loginData) { [weak self] response in
            switch response {
            case .success(let registrationData):
                if let user = registrationData, let user = user {
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
