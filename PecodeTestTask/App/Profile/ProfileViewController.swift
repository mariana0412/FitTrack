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
    
//    @objc private func saveButtonTapped() {
//        guard let viewModel = viewModel else { return }
//        let optionSwitches = optionsContainer.arrangedSubviews.compactMap { $0 as? OptionSwitch }
//        
//        guard viewModel.validateOptions(from: optionSwitches) else { return }
//        viewModel.updateOptions(from: optionSwitches)
//        
    @objc private func saveButtonTapped() {
        let optionSwitches = optionsContainer.arrangedSubviews.compactMap { $0 as? OptionSwitch }
            
        guard validateOptions(optionSwitches) else { return }
        
        validateAndUpdateOptions()
        
        let editedName = name.textFieldText ?? ""
        let selectedImage = imageWasChanged ? profileImage.image : nil
        
        viewModel?.editProfile(newName: editedName, newImage: selectedImage) { [weak self] successful in
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
    
    private func validateOptions(_ optionSwitches: [OptionSwitch]) -> Bool {
        var isValid = true

        optionSwitches.forEach { optionSwitch in
            if let optionName = OptionDataName(rawValue: optionSwitch.optionName) {
                if viewModel?.validateOption(optionName: optionName, value: optionSwitch.optionValue) == true {
                    optionSwitch.setNormalState()
                } else {
                    optionSwitch.setErrorState()
                    isValid = false
                }
            }
        }

        return isValid
    }

    private func validateAndUpdateOptions() {
        var newSelectedOptions = [OptionData]()
        
        optionsContainer.arrangedSubviews.enumerated().forEach { index, view in
            if let optionSwitch = view as? OptionSwitch,
               let optionName = OptionDataName(rawValue: optionSwitch.optionName) {
                
                let value = Double(optionSwitch.optionValue ?? "") ?? 0.0
                let isShown = optionSwitch.optionSwitch.isOn


                let currentTimestamp = Int(Date().timeIntervalSince1970)
                let existingOption = viewModel?.selectedOptions.first { $0.optionName == optionName }

                if var option = existingOption, let lastValue = option.valueArray.last, let lastValue, lastValue != value {
                    if let lastTimestamp = option.dateArray.last, currentTimestamp - lastTimestamp > 10 {
                        option.valueArray.append(value)
                        option.dateArray.append(currentTimestamp)
                        option.changedValue = value - lastValue
                    } else {
                        option.valueArray.removeLast()
                        let newLastValue = option.valueArray.last
                        option.valueArray.append(value)
                        
                        option.dateArray.removeLast()
                        option.dateArray.append(currentTimestamp)
                        
                        if let newLastValue, let newLastValue {
                            option.changedValue = value - newLastValue
                        }
                    }
                    
                    option.isShown = isShown
                    newSelectedOptions.append(option)
                } else if var option = existingOption, let wasShown = option.isShown, wasShown != isShown {
                    option.isShown = isShown
                    newSelectedOptions.append(option)
                } else if let option = existingOption, let lastValue = option.valueArray.last, let lastValue, lastValue == value {
                    newSelectedOptions.append(option)
                } else {
                    let newOption = OptionData(optionName: optionName,
                                               valueArray: [value],
                                               dateArray: [currentTimestamp],
                                               isShown: isShown)
                    newSelectedOptions.append(newOption)
                }
        
            }
        }

        viewModel?.selectedOptions = newSelectedOptions
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
