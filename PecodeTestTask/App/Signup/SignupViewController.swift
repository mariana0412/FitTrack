//
//  SignUpViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import UIKit

final class SignupViewController: BaseViewController {
    
    var viewModel: SignupViewModel?
    
    @IBOutlet private weak var superheroLabel: UILabel!
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
        superheroLabel.text = viewModel?.superheroText
        superheroLabel.textColor = .primaryYellow
        superheroLabel.font = Fonts.futuraBold
        
        createYourAccountLabel.text = viewModel?.createYourAccountText
        createYourAccountLabel.textColor = .primaryWhite
        createYourAccountLabel.font = Fonts.sairaLargeRegular
        
        name.labelText = viewModel?.nameText
        name.labelFont = Fonts.textFieldLabel
        name.textFieldText = viewModel?.namePlaceholderText
        name.textFieldFont = Fonts.textFieldPlaceholder
        
        email.labelText = viewModel?.emailText
        email.labelFont = Fonts.textFieldLabel
        email.textFieldText = viewModel?.emailPlaceholderText
        email.textFieldFont = Fonts.textFieldPlaceholder
        
        password.labelText = viewModel?.passwordText
        password.labelFont = Fonts.textFieldLabel
        password.textFieldText = viewModel?.passwordPlaceholderText
        password.textFieldFont = Fonts.textFieldPlaceholder
        
        confirmPassword.labelText = viewModel?.confirmPasswordText
        confirmPassword.labelFont = Fonts.textFieldLabel
        confirmPassword.textFieldText = viewModel?.confirmPasswordPlaceholderText
        confirmPassword.textFieldFont = Fonts.textFieldPlaceholder
        
        signupButton.titleLabel?.text = viewModel?.signButtonText
        signupButton.setupButtonFont(font: Fonts.sairaSmallRegular, color: .black)
        
        haveAccountLabel.text = viewModel?.haveAccountText
        haveAccountLabel.font = Fonts.sairaSmallLight
        
        loginButton.titleLabel?.text = viewModel?.loginButtonText
        loginButton.setupButtonFont(font: Fonts.sairaSmallMedium, color: .primaryYellow)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func signupButtonTapped() {
        view.endEditing(true)
        
        guard let nameText = name.textFieldText,
              let emailText = email.textFieldText,
              let passwordText = password.textFieldText,
              let confirmPasswordText = confirmPassword.textFieldText else {
            return
        }
        
        let registrationData = RegistrationData(userName: nameText, 
                                                email: emailText,
                                                sex: nil,
                                                password: passwordText)
                
        signupButton.isEnabled = false
        signupButton.backgroundColor = UIColor.primaryWhite
        
        viewModel?.signupUser(with: registrationData, 
                              confirmPassword: confirmPasswordText) { [weak self] validationResults, errorMessage in
            self?.signupButton.isEnabled = true
            self?.signupButton.backgroundColor = UIColor.primaryYellow
            self?.updateValidationUI(validationResults)
            if let errorMessage = errorMessage {
                let alert = AlertUtils.createAlert(message: errorMessage)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func loginButtonTapped() {
        viewModel?.navigateToLogin()
    }
    
    private func updateValidationUI(_ validationResults: [String: Bool]) {
        name.currentState = validationResults["name"] == true ? .normal : .error
        email.currentState = validationResults["email"] == true ? .normal : .error
        password.currentState = validationResults["password"] == true ? .normal : .error
        confirmPassword.currentState = validationResults["confirmPassword"] == true ? .normal : .error
    }

}
