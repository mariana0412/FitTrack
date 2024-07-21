//
//  ProfileViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let backArrowIcon = "chevron.left"
            static let backArrowIconSize: CGFloat = 13
            static let instructionNumberOfLines = 2
        }
    }
    
    var viewModel: ProfileViewModel?
    
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var name: CustomTextFieldView!
    @IBOutlet private weak var instruction: UILabel!
    @IBOutlet private weak var addOptionsButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    static func instantiate() -> ProfileViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.profile, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.profileViewController) as! ProfileViewController
    }
    
    private func setupUI() {
        setupNavigationItem()
        
        guard let viewModel = viewModel else { return }
        
        updateBackgroundImage(named: viewModel.backgroundImageName)
        profileImage.image = viewModel.profileImage
        
        name.labelText = ProfileViewModel.Texts.name
        name.labelFont = Fonts.helveticaNeue18
        name.textFieldText = viewModel.user?.userName
        name.textFieldFont = Fonts.helveticaNeue16
        
        instruction.text = ProfileViewModel.Texts.instruction
        instruction.numberOfLines = Constants.Layout.instructionNumberOfLines
        instruction.textColor = .secondaryGray
        instruction.font = Fonts.sairaLight16
        
        addOptionsButton.titleLabel?.text = ProfileViewModel.Texts.addOptionsButton
        addOptionsButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
    }
    
    private func setupNavigationItem() {
        setupNavigationItemTitle()
        setupNavigationItemLeftBarButton()
        setupNavigationItemRightBarButton()
    }
    
    private func setupNavigationItemTitle() {
        let titleLabel = UILabel()
        titleLabel.text = ProfileViewModel.Texts.NavigationItem.title
        titleLabel.font = Fonts.sairaMedium18
        titleLabel.textColor = .primaryWhite
        navigationItem.titleView = titleLabel
    }
    
    private func setupNavigationItemLeftBarButton() {
        let backButton = UIButton(type: .system)
        
        let chevronLeft = UIImage(systemName: Constants.Layout.backArrowIcon)?.withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.Layout.backArrowIconSize, weight: .medium))
        let tintedChevronLeft = chevronLeft?.withTintColor(.primaryYellow, renderingMode: .alwaysOriginal)
        backButton.setImage(tintedChevronLeft, for: .normal)
        
        backButton.setTitle("  \(ProfileViewModel.Texts.NavigationItem.leftBarButton)", for: .normal)
        backButton.titleLabel?.font = Fonts.sairaMedium18
        backButton.setTitleColor(.primaryYellow, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        
        navigationItem.leftBarButtonItem = backBarButtonItem
    }
    
    private func setupNavigationItemRightBarButton() {
        let saveButton = UIButton(type: .custom)
        
        saveButton.setTitle(ProfileViewModel.Texts.NavigationItem.rightBarButton, for: .normal)
        saveButton.titleLabel?.font = Fonts.sairaMedium18
        saveButton.setTitleColor(.secondaryGray, for: .disabled)
        saveButton.isEnabled = false
        saveButton.setTitleColor(.primaryYellow, for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToHome()
    }
    
    @objc private func saveButtonTapped() {
        
    }
    
}
