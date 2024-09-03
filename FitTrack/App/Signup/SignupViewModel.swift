//
//  SignUpViewModel.swift
//  FitTrack
//
//  Created by Mariana Piz on 10.07.2024.
//

import Foundation
import UIKit

class SignupViewModel {
    
    private enum Constants {
        enum Validation {
            static let fullNamePattern = #"^[a-zA-Z0-9-''']+(?: [a-zA-Z0-9-''']+)*$"#
            static let emailPattern = #"^\S+@\S+\.\S+$"#
            static let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        }
        static let alertIconName = "exclamationmark.triangle"
    }
    
    private var coordinator: SignupCoordinator?
    
    let superheroText = "SUPERHERO"
    let createYourAccountText = "Create your account"
    let nameText = "Name"
    let namePlaceholderText = "Enter name"
    let emailText = "Email"
    let emailPlaceholderText = "Enter email"
    let passwordText = "Password"
    let passwordPlaceholderText = "Create password"
    let confirmPasswordText = "Confirm Password"
    let confirmPasswordPlaceholderText = "Enter password"
    let signButtonText = "Sign up"
    let haveAccountText = "Already have an account?"
    let loginButtonText = "Log in"
    
    init(coordinator: SignupCoordinator?) {
        self.coordinator = coordinator
    }
    
    func signupUser(with registrationData: RegistrationData, 
                    confirmPassword: String,
                    completion: @escaping ([String: Bool], String?) -> Void) {
        let validationResults = validateFields(name: registrationData.userName, email: registrationData.email, password: registrationData.password, confirmPassword: confirmPassword)
            
        
        guard validationResults["name"] == true,
              validationResults["email"] == true,
              validationResults["password"] == true,
              validationResults["confirmPassword"] == true else {
            completion(validationResults, nil)
            return
        }
        
        FirebaseService.shared.createUser(with: registrationData) { [weak self] response in
            switch response {
            case .success:
                self?.navigateToSplash(with: registrationData.email)
                completion(validationResults, nil)
            case .failure(let error):
                self?.navigateToAlert(message: error.localizedDescription)
                completion(validationResults, error.localizedDescription)
            case .unknown:
                self?.navigateToAlert(message: "Unknown error occurred.")
                completion(validationResults, "Unknown error occurred.")
            }
        }
    }
    
    private func validateFields(name: String, 
                                email: String,
                                password: String,
                                confirmPassword: String) -> [String: Bool] {
        var results: [String: Bool] = [:]

        results["name"] = validateField(text: name, regex: Constants.Validation.fullNamePattern)
        results["email"] = validateField(text: email, regex: Constants.Validation.emailPattern)
        results["password"] = validateField(text: password, regex: Constants.Validation.passwordPattern)
        results["confirmPassword"] = password == confirmPassword
        
        return results
    }
    
    private func validateField(text: String, regex: String) -> Bool {
        NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: text)
    }
    
    func navigateToSplash(with email: String) {
        coordinator?.navigateToSplash()
    }
    
    func navigateToLogin() {
        coordinator?.navigateToLogin()
    }
    
    func navigateToAlert(message: String) {
        let errorIcon = UIImage(systemName: Constants.alertIconName)
        let alertContent = AlertContent(alertType: .noButtons, message: message, icon: errorIcon)
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
}
