//
//  SignUpViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import UIKit
import FirebaseAuth

final class SignupViewController: BaseViewController {
    var viewModel: SignupViewModel?
    
    @IBOutlet weak var createYourAccountLabel: UILabel!
    @IBOutlet weak var haveAccountLabel: UILabel!
    
    @IBOutlet weak var name: CustomTextFieldView!
    @IBOutlet weak var email: CustomTextFieldView!
    @IBOutlet weak var password: CustomTextFieldView!
    @IBOutlet weak var confirmPassword: CustomTextFieldView!
    
    @IBOutlet weak var signupButton: CustomButton!
    @IBOutlet weak var loginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
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
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func signupButtonTapped() {
        guard let name = name.textField.text, !name.isEmpty,
              let email = email.textField.text, !email.isEmpty,
              let password = password.textField.text, !password.isEmpty,
              let confirmPassword = confirmPassword.textField.text, !confirmPassword.isEmpty else {
            showAlert(message: "Please fill in all fields.")
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
    
    private func showAlert(title: String = "Alert", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
