//
//  ForgotPasswordViewController.swift
//  FitTrack
//
//  Created by Mariana Piz on 17.07.2024.
//

import UIKit

final class ForgotPasswordViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let explanationNumberOfLines: Int = 0
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
        setupDismissKeyboardOnTap()
    }
    
    static func instantiate() -> ForgotPasswordViewController {
        return instantiate(fromStoryboard: StoryboardConstants.forgotPassword,
                           viewControllerIdentifier: ViewControllerIdentifiers.forgotPasswordViewController)
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
        explanationLabel.textColor = .secondaryGray
        explanationLabel.font = Fonts.sairaLight16
        
        continueButton.titleLabel?.text = viewModel?.continueButtonText
        continueButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
        
        backToLoginButton.titleLabel?.text = viewModel?.backToLogintButtonText
        backToLoginButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
    }
    
    private func setupActions() {
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(backToLoginButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        dismissKeyboard()
        
        guard let emailText = email.textFieldText else { return }

        updateContinueButton()

        viewModel?.resetPassword(email: emailText) { [weak self] _ in
            self?.updateContinueButton()
        }
    }
    
    private func updateContinueButton() {
        continueButton.isEnabled.toggle()
        continueButton.backgroundColor = continueButton.isEnabled ? .primaryYellow : .primaryWhite
    }
    
    @objc private func backToLoginButtonTapped() {
        viewModel?.navigateToLogin()
    }
    
}
