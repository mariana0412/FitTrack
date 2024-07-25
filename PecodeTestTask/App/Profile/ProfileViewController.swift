//
//  ProfileViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

final class ProfileViewController: BaseViewController, OptionSwitchDelegate {
    func optionSwitchDidChange(_ optionSwitch: OptionSwitch) {
        saveButton?.isEnabled = true
    }
    
    func optionValueDidChange(_ optionSwitch: OptionSwitch, newValue: String) {
        saveButton?.isEnabled = true
    }
    
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
            title: ProfileViewModel.Constants.Texts.navigationItemTitle,
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
            profileImage.image = UIImage(named: ProfileViewModel.Constants.Texts.defaultImageName)
        }
        
        name.labelText = ProfileViewModel.Constants.Texts.name
        name.labelFont = Fonts.helveticaNeue18
        name.textFieldText = viewModel.user?.userName
        name.textFieldFont = Fonts.helveticaNeue16
        
        instruction.text = ProfileViewModel.Constants.Texts.instruction
        instruction.numberOfLines = Constants.Layout.instructionNumberOfLines
        instruction.textColor = .secondaryGray
        instruction.font = Fonts.sairaLight16
        
        addOptionsButton.titleLabel?.text = ProfileViewModel.Constants.Texts.addOptionsButton
        addOptionsButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
    }
    
    private func configureSaveButtonInitialState() {
        saveButton?.setTitleColor(.secondaryGray, for: .disabled)
        saveButton?.setTitleColor(.primaryYellow, for: .normal)
        saveButton?.isEnabled = false
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
        guard validateOptions() else { return }
        
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
    
    private func validateOptions() -> Bool {
        var updatedOptions: [OptionData] = []
        var isValid = true

        optionsContainer.arrangedSubviews.enumerated().forEach { index, view in
            if let optionSwitch = view as? OptionSwitch,
               let optionName = OptionDataName(rawValue: optionSwitch.optionName) {
                let value = Double(optionSwitch.optionValue ?? "") ?? 0.0
                let isShown = optionSwitch.optionSwitch.isOn
                updatedOptions.append(OptionData(optionName: optionName, value: value, isShown: isShown))
                
                if viewModel?.validateOption(optionName: optionName, value: optionSwitch.optionValue) != true {
                    optionSwitch.setErrorState()
                    isValid = false
                } else {
                    optionSwitch.setNormalState()
                }
            }
        }

        viewModel?.user?.selectedOptions = updatedOptions
        
        return isValid
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
        saveButton?.isEnabled = true
        imageWasChanged = true
    }
    
    func updateSaveButtonState(newName: String) {
        saveButton?.isEnabled = viewModel?.nameIsChanged(newName: newName) == true
    }
    
    func updateSelectedOptions() {
        updateState()
    }
    
    private func updateState() {
        let hasSelectedOptions = viewModel?.user?.selectedOptions.count ?? 0 > 0
        instruction.isHidden = hasSelectedOptions
        optionsContainer.isHidden = !hasSelectedOptions
        
        if hasSelectedOptions {
            updateOptions()
        }
    }
    
    private func updateOptions() {
        optionsContainer.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        viewModel?.user?.selectedOptions.forEach { option in
            let optionSwitch = OptionSwitch()
            
            var optionValueString = ""
            if let optionValue = option.value {
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
}
