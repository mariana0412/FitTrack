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
    
    private var saveButton: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupImagePicker()
        
        name.textField.delegate = self
    }
    
    static func instantiate() -> ProfileViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.profile, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.profileViewController) as! ProfileViewController
    }
    
    private func setupUI() {
        setupNavigationItem()
        
        guard let viewModel = viewModel else { return }
        
        updateBackgroundImage(named: viewModel.backgroundImageName)
        
        if let profileImageData = viewModel.user?.profileImage {
            profileImage.setImageWithBorder(image: UIImage(data: profileImageData))
        } else {
            profileImage.image = UIImage(named: ProfileViewModel.Texts.defaultImageName)
        }
        
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
        saveButton.isEnabled = false
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        
        navigationItem.rightBarButtonItem = saveBarButtonItem
        
        self.saveButton = saveButton
        configureSaveButtonInitialState()
    }
    
    private func configureSaveButtonInitialState() {
        saveButton?.setTitleColor(.secondaryGray, for: .disabled)
        saveButton?.setTitleColor(.primaryYellow, for: .normal)
        saveButton?.isEnabled = false
    }
    
    private func setupActions() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToHome()
    }
    
    @objc private func saveButtonTapped() {
        if let editedName = name.textFieldText,
           let selectedImage = profileImage.image {
            viewModel?.editProfile(newName: editedName, newImage: selectedImage) { [weak self] success, message in
                if success {
                    self?.view.showCustomAlert(message: "Profile updated successfully.")
                    self?.name.textFieldText = editedName 
                    self?.profileImage.setImageWithBorder(image: selectedImage)
                } else {
                    self?.view.showCustomAlert(message: message ?? "An error occurred while updating profile.")
                }
            }
        }
    }
    
    private func setupImagePicker() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func profileImageTapped() {
        presentImagePicker()
    }
    
    func setSelectedImage(_ selectedImage: UIImage) {
        profileImage.setImageWithBorder(image: selectedImage)
        saveButton?.isEnabled = true
    }
    
    private func updateSaveButtonState() {
        let newName = name.textFieldText
        let oldName = viewModel?.user?.userName
        let nameIsChanged = (newName != oldName) && newName?.isEmpty != true
        
        let newImage: UIImage = profileImage.image ?? UIImage()
        let oldImage: UIImage
        if let profileImageData = viewModel?.user?.profileImage {
            oldImage = UIImage(data: profileImageData) ?? UIImage()
        } else {
            oldImage = UIImage(named: ProfileViewModel.Texts.defaultImageName) ?? UIImage()
        }
        let imageIsChanged = newImage != oldImage
        
        saveButton?.isEnabled = nameIsChanged || imageIsChanged
    }
    
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
    }
}
