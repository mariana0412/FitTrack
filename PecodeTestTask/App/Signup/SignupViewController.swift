//
//  SignUpViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import UIKit
import FirebaseAuth

final class SignupViewController: BaseViewController {
    
    private enum Constants {
        enum Validation {
            static let fullNamePattern = #"^[a-zA-Z0-9-''']+(?: [a-zA-Z0-9-''']+)*$"#
            static let emailPattern = #"^\S+@\S+\.\S+$"#
            static let passwordPattern = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
        }
    }
    
    var viewModel: SignupViewModel?
    
    @IBOutlet private weak var createYourAccountLabel: UILabel!
    @IBOutlet private weak var haveAccountLabel: UILabel!
    
    @IBOutlet private weak var name: CustomTextFieldView!
    @IBOutlet private weak var email: CustomTextFieldView!
    @IBOutlet private weak var password: CustomTextFieldView!
    @IBOutlet private weak var confirmPassword: CustomTextFieldView!
    
    @IBOutlet private weak var signupButton: CustomButton!
    @IBOutlet private weak var loginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        name.validationRegex = Constants.Validation.fullNamePattern
        email.validationRegex = Constants.Validation.emailPattern
        password.validationRegex = Constants.Validation.passwordPattern
        confirmPassword.validationRegex = Constants.Validation.passwordPattern
    }
    
    static func instantiate() -> SignupViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.signup, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.signupViewController) as! SignupViewController
    }
    
    private func setupUI() {
        createYourAccountLabel.font = UIFont(name: "Saira-Regular", size: 24)
        haveAccountLabel.font = UIFont(name: "Saira-Regular", size: 16)
        
        signupButton.titleLabel?.font = UIFont(name: "Saira-Regular", size: 16)
        loginButton.titleLabel?.font = UIFont(name: "Saira-Regular", size: 16)
        
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signupButtonTapped() {
        guard let name = name.textField.text, !name.isEmpty,
              let email = email.textField.text, !email.isEmpty,
              let password = password.textField.text, !password.isEmpty,
              let confirmPassword = confirmPassword.textField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return
        }
        
        if !(validateField(self.name, alertMessage: "Name is not valid")
            && validateField(self.email, alertMessage: "Email is not valid")
            && validateField(self.password, alertMessage: "Password is not valid")
            && validateField(self.confirmPassword, alertMessage: "Confirm password is not valid")) {
            return
        }
        
        guard password == confirmPassword else {
            showAlert(message: "Passwords do not match.")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
            } else {
                self.showAlert(message: "Registration successful!")
            }
        }
    }
    
    private func validateField(_ textField: CustomTextFieldView, alertMessage: String) -> Bool {
        if textField.validateText() {
            return true
        } else {
            showAlert(message: alertMessage)
            return false
        }
    }
    
    private func showAlert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
