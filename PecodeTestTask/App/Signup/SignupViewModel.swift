//
//  SignUpViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import Foundation

class SignupViewModel {
    
    private enum Constants {
        enum Validation {
            static let fullNamePattern = #"^[a-zA-Z0-9-''']+(?: [a-zA-Z0-9-''']+)*$"#
            static let emailPattern = #"^\S+@\S+\.\S+$"#
            static let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        }
    }
    
    private var coordinator: SignupCoordinator?
    
    init(coordinator: SignupCoordinator?) {
        self.coordinator = coordinator
    }
    
    func signupUser(with registrationData: RegistrationData, confirmPassword: String, completion: @escaping ([String: Bool], String?) -> Void) {
        let validationResults = validateFields(name: registrationData.userName, email: registrationData.email, password: registrationData.password, confirmPassword: confirmPassword)
            
        
        guard validationResults["name"] == true,
              validationResults["email"] == true,
              validationResults["password"] == true,
              validationResults["confirmPassword"] == true else {
            completion(validationResults, nil)
            return
        }
        
        FirebaseService.shared.createUser(with: registrationData) { response in
            switch response {
            case .success:
                self.navigateToSplash(with: registrationData.email)
                completion(validationResults, nil)
            case .failure(let error):
                completion(validationResults, error.localizedDescription)
            case .unknown:
                completion(validationResults, "Unknown error occurred.")
            }
        }
    }
    
    private func validateFields(name: String, email: String, password: String, confirmPassword: String) -> [String: Bool] {
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
}
