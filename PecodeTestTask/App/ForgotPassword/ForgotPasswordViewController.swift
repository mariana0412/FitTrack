//
//  ForgotPasswordViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.07.2024.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let explanationNumberOfLines: Int = 3
            static let minExplanationFontSize: CGFloat = 15.8
        }
    }
        
    var viewModel: ForgotPasswordViewModel?
    
    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var forgotPasswordLabel: UILabel!
    @IBOutlet private weak var email: CustomTextFieldView!
    @IBOutlet private weak var explanationLabel: UILabel!
    @IBOutlet private weak var continueButton: CustomButton!
    @IBOutlet private weak var backToLoginButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    static func instantiate() -> ForgotPasswordViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.forgotPassword, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.forgotPasswordViewController) as! ForgotPasswordViewController
    }
    
    private func setupUI() {
        superheroLabel.text = viewModel?.superheroText
        superheroLabel.textColor = .primaryYellow
        superheroLabel.font = Fonts.futuraBold
        
        forgotPasswordLabel.text = viewModel?.forgotPasswordText
        forgotPasswordLabel.font = Fonts.sairaRegular24
        
        email.labelText = viewModel?.emailText
        email.labelFont = Fonts.helveticaNeue18
        email.textFieldText = viewModel?.emailPlaceholderText
        email.textFieldFont = Fonts.helveticaNeue16
        
        explanationLabel.text = viewModel?.explanationText
        explanationLabel.numberOfLines = Constants.Layout.explanationNumberOfLines
        explanationLabel.adjustsFontSizeToFitWidth = true
        explanationLabel.minimumScaleFactor = Constants.Layout.minExplanationFontSize / explanationLabel.font.pointSize
        explanationLabel.textColor = .primaryGray
        explanationLabel.font = Fonts.sairaLight16
        
        continueButton.titleLabel?.text = viewModel?.continueButtonText
        continueButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
        
        backToLoginButton.titleLabel?.text = viewModel?.backToLogintButtonText
        backToLoginButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(backToLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func continueButtonTapped() {
        view.endEditing(true)
        
        guard let emailText = email.textFieldText else {
            return
        }

        continueButton.isEnabled = false
        continueButton.backgroundColor = UIColor.primaryWhite

        viewModel?.resetPassword(email: emailText) { [weak self] errorMessage in
            self?.continueButton.isEnabled = true
            self?.continueButton.backgroundColor = UIColor.primaryYellow
            if errorMessage != nil {
                if let alertErrorMessage = self?.viewModel?.alertErrorMessage,
                   let alertOkButtonText = self?.viewModel?.alertOkButtonText {
                    self?.view.showCustomAlert(
                        message: alertErrorMessage,
                        okButtonTitle: alertOkButtonText,
                        cancelButtonTitle: "Cancel",
                        cancelClickedAction: {
                            self?.viewModel?.navigateToLogin()
                        }
                    )
                }
            } else {
                if let alertOkMessage = self?.viewModel?.alertOkMessage,
                   let alertOkButtonText = self?.viewModel?.alertOkButtonText {
                    self?.view.showCustomAlert(
                        message: alertOkMessage,
                        okButtonTitle: alertOkButtonText,
                        okClickedAction: {
                            self?.viewModel?.navigateToLogin()
                        }
                    )
                }
            }
        }
    }
    
    @objc private func backToLoginButtonTapped() {
        viewModel?.navigateToLogin()
    }
    
}
