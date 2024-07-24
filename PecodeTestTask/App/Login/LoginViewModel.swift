//
//  LoginViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import FirebaseAuth

class LoginViewModel {
    
    private enum Constants {
        static let alertIconName = "exclamationmark.triangle"
    }
    
    private var coordinator: LoginCoordinator?
    
    let superheroText = "SUPERHERO"
    let loginToYourAccountText = "Login to your account"
    let emailText = "Email"
    let emailPlaceholderText = "Enter email"
    let passwordText = "Password"
    let passwordPlaceholderText = "Enter password"
    let forgotPasswordText = "Forgot Password?"
    let loginButtonText = "Login"
    let backToSignupButtonText = "Back to register"

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
                self?.navigateToAlert(message: error.localizedDescription)
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred.")
            }
        }
    }
    
    private func handleNavigation(user: UserData) {
        if user.sex != .unknown {
            navigateToHome(userSex: user.sex)
        } else {
            navigateToSplash()
        }
    }

    private func navigateToSplash() {
        coordinator?.navigateToSplash()
    }
    
    private func navigateToHome(userSex: UserSex) {
        coordinator?.navigateToHome(userSex: userSex)
    }
    
    func navigateToSignup() {
        coordinator?.navigateToSignup()
    }
    
    func navigateToForgotPassword() {
        coordinator?.navigateToForgotPassword()
    }
    
    func navigateToAlert(message: String) {
        let errorIcon = UIImage(systemName: Constants.alertIconName)
        let alertContent = AlertContent(alertType: .noButtons, message: message, icon: errorIcon)
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
}
