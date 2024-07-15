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
            static let sairaLargeRegular = UIFont(name: "Saira-Regular", size: 24)
            static let sairaSmallRegular = UIFont(name: "Saira-Regular", size: 16)
            static let sairaSmallMedium = UIFont(name: "Saira-Medium", size: 16)
        }
    }
    
    var viewModel: LoginViewModel?
    
    @IBOutlet weak var loginToYourAccountLabel: UILabel!
    
    @IBOutlet weak var email: CustomTextFieldView!
    @IBOutlet weak var password: CustomTextFieldView!
    
    @IBOutlet weak var forgotPasswordButton: CustomButton!
    @IBOutlet weak var loginButton: CustomButton!
    
    
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
        loginToYourAccountLabel.font = Constants.Layout.sairaLargeRegular
        forgotPasswordButton.setupButtonFont(font: Constants.Layout.sairaSmallMedium, color: .primaryYellow)
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
        
        guard let emailText = email.textField.text,
              let passwordText = password.textField.text else {
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
