//
//  LoginViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import UIKit

final class LoginViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let futuraBold = UIFont(name: "Futura-Bold", size: 32)
            static let sairaLargeRegular = UIFont(name: "Saira-Regular", size: 24)
            static let sairaSmallRegular = UIFont(name: "Saira-Regular", size: 16)
            static let sairaSmallMedium = UIFont(name: "Saira-Medium", size: 16)
            static let textFieldLabel = UIFont(name: "Helvetica Neue", size: 18)
            static let textFieldPlaceholder = UIFont(name: "Helvetica Neue", size: 16)
        }
    }
    
    var viewModel: LoginViewModel?
    
    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var loginToYourAccountLabel: UILabel!
    
    @IBOutlet private weak var email: CustomTextFieldView!
    @IBOutlet private weak var password: CustomTextFieldView!
    
    @IBOutlet private weak var forgotPasswordButton: CustomButton!
    @IBOutlet private weak var loginButton: CustomButton!
    
    
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
        superheroLabel.font = Constants.Layout.futuraBold
        
        loginToYourAccountLabel.text = viewModel?.loginToYourAccountText
        loginToYourAccountLabel.font = Constants.Layout.sairaLargeRegular
        
        email.labelText = viewModel?.emailText
        email.labelFont = Constants.Layout.textFieldLabel
        email.textFieldText = viewModel?.emailPlaceholderText
        email.textFieldFont = Constants.Layout.textFieldPlaceholder
        
        password.labelText = viewModel?.passwordText
        password.labelFont = Constants.Layout.textFieldLabel
        password.textFieldText = viewModel?.passwordPlaceholderText
        password.textFieldFont = Constants.Layout.textFieldPlaceholder
        
        forgotPasswordButton.titleLabel?.text = viewModel?.forgotPasswordText
        forgotPasswordButton.setupButtonFont(font: Constants.Layout.sairaSmallMedium, color: .primaryYellow)
        
        loginButton.titleLabel?.text = viewModel?.loginButtonText
        loginButton.setupButtonFont(font: Constants.Layout.sairaSmallRegular, color: .black)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
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
        
}
