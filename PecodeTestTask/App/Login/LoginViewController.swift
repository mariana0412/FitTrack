//
//  LoginViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    var viewModel: LoginViewModel?
    
    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var loginToYourAccountLabel: UILabel!
    
    @IBOutlet private weak var email: CustomTextFieldView!
    @IBOutlet private weak var password: CustomTextFieldView!
    
    @IBOutlet private weak var forgotPasswordButton: CustomButton!
    @IBOutlet private weak var loginButton: CustomButton!
    @IBOutlet weak var backToSignupButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    static func instantiate() -> LoginViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.login, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.loginViewController) as! LoginViewController
    }
    
    private func setupUI() {
        superheroLabel.text = viewModel?.superheroText
        superheroLabel.textColor = .primaryYellow
        superheroLabel.font = Fonts.futuraBold
        
        loginToYourAccountLabel.text = viewModel?.loginToYourAccountText
        loginToYourAccountLabel.font = Fonts.sairaRegular24
        
        email.labelText = viewModel?.emailText
        email.labelFont = Fonts.helveticaNeue18
        email.textFieldText = viewModel?.emailPlaceholderText
        email.textFieldFont = Fonts.helveticaNeue16
        
        password.labelText = viewModel?.passwordText
        password.labelFont = Fonts.helveticaNeue18
        password.textFieldText = viewModel?.passwordPlaceholderText
        password.textFieldFont = Fonts.helveticaNeue16
        
        forgotPasswordButton.titleLabel?.text = viewModel?.forgotPasswordText
        forgotPasswordButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
        
        backToSignupButton.titleLabel?.text = viewModel?.backToSignupButtonText
        backToSignupButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
        
        loginButton.titleLabel?.text = viewModel?.loginButtonText
        loginButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordButtonTapped), for: .touchUpInside)
        backToSignupButton.addTarget(self, action: #selector(backToSignupButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func loginButtonTapped() {
        view.endEditing(true)
        
        guard let emailText = email.textFieldText,
              let passwordText = password.textFieldText else {
            return
        }
        
        let loginData = LoginData(email: emailText,
                                  password: passwordText)
                
        loginButton.isEnabled = false
        loginButton.backgroundColor = UIColor.primaryWhite
        viewModel?.loginUser(with: loginData) { [weak self] errorMessage in
            self?.loginButton.isEnabled = true
            self?.loginButton.backgroundColor = UIColor.primaryYellow
            if let errorMessage = errorMessage {
                let alert = AlertUtils.createAlert(message: errorMessage)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc private func forgotPasswordButtonTapped() {
        viewModel?.navigateToForgotPassword()
    }
    
    @objc private func backToSignupButtonTapped() {
        viewModel?.navigateToSignup()
    }
    
}
