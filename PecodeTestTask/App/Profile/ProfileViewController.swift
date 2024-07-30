//
//  ProfileViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

final class ProfileViewController: BaseViewController, OptionSwitchDelegate {
    
    private enum Constants {
        enum Layout {
            static let instructionNumberOfLines = 2
        }
    }
    
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var name: CustomTextFieldView!
    @IBOutlet private weak var instruction: UILabel!
    @IBOutlet weak var optionsContainer: UIStackView!
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
        updateSelectedOptions()
        
        name.textField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let navigationButtons = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? "",
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
            profileImage.image = UIImage(named: viewModel.defaultImageName)
        }
        
        name.labelText = viewModel.name
        name.labelFont = Fonts.helveticaNeue18
        name.textFieldText = viewModel.user?.userName
        name.textFieldFont = Fonts.helveticaNeue16
        
        instruction.text = viewModel.instruction
        instruction.numberOfLines = Constants.Layout.instructionNumberOfLines
        instruction.textColor = .secondaryGray
        instruction.font = Fonts.sairaLight16
        
        addOptionsButton.titleLabel?.text = viewModel.addOptionsButton
        addOptionsButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
    }
    
    private func configureSaveButtonInitialState() {
        saveButton?.setTitleColor(.secondaryGray, for: .disabled)
        saveButton?.setTitleColor(.primaryYellow, for: .normal)
        disableSaveButton()
    }
    
    private func setupActions() {
        addOptionsButton.addTarget(self, action: #selector(addOptionsButtonTapped), for: .touchUpInside)
                
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
        guard let viewModel else { return }
        
        let optionSwitches = optionsContainer.arrangedSubviews.compactMap { $0 as? OptionSwitch }
        guard viewModel.optionsAreValid(optionSwitches) else { return }
        viewModel.prepareOptionsForEditing(optionSwitches)
        
        let editedName = name.textFieldText ?? ""
        let selectedImage = imageWasChanged ? profileImage.image : nil
        
        viewModel.editProfile(newName: editedName, newImage: selectedImage) { [weak self] successful in
            if successful {
                self?.imageWasChanged = false
                self?.disableSaveButton()
                self?.hideKeyboard()
                self?.delegate?.profileDidUpdate()
                self?.updateSelectedOptions()
                self?.disableSaveButton()
            }
        }
    }
    
    @objc private func addOptionsButtonTapped() {
        viewModel?.navigateToOptions()
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
        enableSaveButton()
        imageWasChanged = true
    }
    
    func updateSaveButtonState(newName: String) {
        if viewModel?.selectedOptionsChanged() == false {
            saveButton?.isEnabled = viewModel?.nameIsChanged(newName: newName) == true
        }
    }
    
    func updateSelectedOptions() {
        updateState()
    }
    
    private func updateState() {
        let hasSelectedOptions = viewModel?.selectedOptions.count ?? 0 > 0
        instruction.isHidden = hasSelectedOptions
        optionsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        optionsContainer.isHidden = !hasSelectedOptions
        
        if hasSelectedOptions {
            updateOptions()
        }
        let optionsChanged = viewModel?.selectedOptionsChanged() ?? false
        if optionsChanged {
            enableSaveButton()
        }
    }
    
    private func updateOptions() {
        optionsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        viewModel?.selectedOptions.forEach { option in
            let optionSwitch = OptionSwitch()
            
            var optionValueString = ""
            if let optionValue = option.valueArray.last, 
                let optionValue {
                optionValueString = String(optionValue)
            }
            
            optionSwitch.configure(optionName: option.optionName.rawValue,
                                   value: optionValueString,
                                   metric: option.optionName.metricValue,
                                   isSwitchOn: option.isShown ?? false)
            optionSwitch.delegate = self
            optionsContainer.addArrangedSubview(optionSwitch)
        }
    }
    
    func optionSwitchDidChange(_ optionSwitch: OptionSwitch) {
        enableSaveButton()
    }
    
    func optionValueDidChange(_ optionSwitch: OptionSwitch, newValue: String) {
        enableSaveButton()
    }
    
    private func enableSaveButton() {
        saveButton?.isEnabled = true
    }
    
    private func disableSaveButton() {
        saveButton?.isEnabled = false
    }
}
