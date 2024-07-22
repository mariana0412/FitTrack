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
            static let instructionNumberOfLines = 2
        }
    }
    
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var name: CustomTextFieldView!
    @IBOutlet private weak var instruction: UILabel!
    @IBOutlet private weak var addOptionsButton: CustomButton!
    
    private var saveButton: UIButton?
    private(set) var imageWasChanged: Bool = false
    var viewModel: ProfileViewModel?
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        setupImagePicker()
        
        name.textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let navigationButtons = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: ProfileViewModel.Texts.NavigationItem.title,
            backAction: #selector(backButtonTapped),
            saveAction: #selector(saveButtonTapped)
        )
        
        if let saveButtonCustomView = navigationButtons.saveButton.customView as? UIButton {
            saveButton = saveButtonCustomView
            configureSaveButtonInitialState()
        }
    }
    
    static func instantiate() -> ProfileViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.profile, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.profileViewController) as! ProfileViewController
    }
    
    private func setupUI() {
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
        let editedName = name.textFieldText ?? ""
        let selectedImage = imageWasChanged ? profileImage.image : nil
        
        viewModel?.editProfile(newName: editedName, newImage: selectedImage) { [weak self] successful in
            if successful {
                self?.imageWasChanged = false
                self?.saveButton?.isEnabled = false
                self?.hideKeyboard()
                self?.delegate?.profileDidUpdate()
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
        imageWasChanged = true
    }
    
    func updateSaveButtonState(newName: String) {
        saveButton?.isEnabled = viewModel?.nameIsChanged(newName: newName) == true
    }
    
}
