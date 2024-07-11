//
//  SignUpViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import UIKit

final class SignupViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let sairaLarge = UIFont(name: "Saira-Regular", size: 24)
            static let sairaSmall = UIFont(name: "Saira-Regular", size: 16)
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
        setupActions()
    }
    
    static func instantiate() -> SignupViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.signup, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.signupViewController) as! SignupViewController
    }
    
    private func setupUI() {
        createYourAccountLabel.font = Constants.Layout.sairaLarge
        haveAccountLabel.font = Constants.Layout.sairaSmall
        
        signupButton.titleLabel?.font = Constants.Layout.sairaSmall
        loginButton.titleLabel?.font = Constants.Layout.sairaSmall
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signupButtonTapped() {
        view.endEditing(true)
        
        guard let nameText = name.textField.text,
              let emailText = email.textField.text,
              let passwordText = password.textField.text,
              let confirmPasswordText = confirmPassword.textField.text else {
            return
        }
        
        let registrationData = RegistrationData(userName: nameText, 
                                                email: emailText,
                                                sex: nil,
                                                password: passwordText)
                
        signupButton.isEnabled = false
        
        viewModel?.signupUser(with: registrationData, 
                              confirmPassword: confirmPasswordText) { [weak self] validationResults, errorMessage in
            self?.signupButton.isEnabled = true
            self?.updateValidationUI(validationResults)
            if let errorMessage = errorMessage {
                let alert = AlertUtils.createAlert(message: errorMessage)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func updateValidationUI(_ validationResults: [String: Bool]) {
        name.currentState = validationResults["name"] == true ? .normal : .error
        email.currentState = validationResults["email"] == true ? .normal : .error
        password.currentState = validationResults["password"] == true ? .normal : .error
        confirmPassword.currentState = validationResults["confirmPassword"] == true ? .normal : .error
    }

}
