//
//  SignUpViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 10.07.2024.
//

import UIKit

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
    
}
