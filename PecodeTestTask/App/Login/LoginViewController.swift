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
    
}
