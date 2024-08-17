//
//  DeleteAccountViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

import UIKit

final class DeleteAccountViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let instructionNumberOfLines = 0
        }
    }
    
    @IBOutlet weak var emailTextField: CustomTextFieldView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var deleteButton: CustomButton!
    
    var viewModel: DeleteAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> DeleteAccountViewController {
        return instantiate(fromStoryboard: StoryboardConstants.deleteAccount,
                           viewControllerIdentifier: ViewControllerIdentifiers.deleteAccountViewController)
    }
    
    private func setupUI() {
        instructionLabel.textColor = .secondaryGray
        instructionLabel.font = Fonts.sairaLight16
        instructionLabel.numberOfLines = Constants.Layout.instructionNumberOfLines
        
        deleteButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
        deleteButton.backgroundColor = .primaryPink
    }
    
    private func bindViewModel() {
        updateBackgroundImage(named: viewModel?.backgroundImageName ?? "")
        
        emailTextField.labelText = viewModel?.emailTextFieldLabel
        emailTextField.textFieldText = viewModel?.emailTextFieldPlaceholderText
        
        instructionLabel.text = viewModel?.instructionText
        
        deleteButton.buttonTitle = viewModel?.deleteButtonText
    }
    
    private func setupActions() {
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func deleteButtonTapped() {
        view.endEditing(true)
        
        guard let enteredEmail = emailTextField.textFieldText else { return }
        
        viewModel?.emailIsValid(enteredEmail: enteredEmail) { [weak self] isValid in
            if isValid {
                self?.emailTextField.currentState = .normal
                self?.viewModel?.navigateToAlert(disableDeleteButton: { [weak self] in
                    self?.disableDeleteButton()
                })
            } else {
                self?.emailTextField.currentState = .error
            }
        }
    }
    
    private func disableDeleteButton() {
        deleteButton.isEnabled = false
        deleteButton.backgroundColor = .primaryWhite
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? "",
            backAction: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToProfile()
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
}
