//
//  ProfileViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class ProfileViewModel {
    
    private enum Constants {
        static let maxNumberOfBytesInData = 1048487
        static let minUpdateInterval = 1
        static let minError = 0.01
    
        enum Validation {
            static let maxHeight: Double = 300
            static let maxWeight: Double = 300
            static let maxValue: Double = 100
            static let minValue: Double = 0
        }
    }
    
    let navigationItemTitle = "Profile"
    let name = "Name"
    let namePlaceholder = "Enter Your Name"
    let instruction = "Select an option to display on the main screen."
    let addOptionsButton = "Add Options"
    let deleteAccountButton = "Delete account"
    let defaultImageName = "noImage"
    
    private var coordinator: ProfileCoordinator?
    
    private(set) var user: UserData?
    private(set) var backgroundImageName = ""
    var selectedOptions: [OptionData] = []
    
    init(coordinator: ProfileCoordinator, user: UserData) {
        self.coordinator = coordinator
        self.user = user
        self.selectedOptions = user.selectedOptions
        self.backgroundImageName = (user.sex == .female) ? "backgroundImageGirl" : "backgroundImageMan"
    }
    
    func editProfile(newName: String, newImage: UIImage?, completion: @escaping (Bool) -> Void) {
        let newName = nameIsChanged(newName: newName) ? newName : nil
        
        var newImageData: Data?
        if let newImage {
            newImageData = newImage.compress(to: Constants.maxNumberOfBytesInData)
        }
        
        let newOptions = selectedOptions

        FirebaseService.shared.updateUserProfile(newName: newName, 
                                                 newImage: newImageData, newOptions: newOptions) { [weak self] response in
            switch response {
            case .success(let updatedUser):
                self?.navigateToAlert(message: "Profile has been saved!")
                completion(true)
                if let user = updatedUser {
                    self?.user = user
                    self?.selectedOptions = user?.selectedOptions ?? []
                    
                    NotificationCenter.default.post(name: .profileDidUpdate, object: nil, userInfo: ["user": user as Any])
                }
            case .failure(let error):
                self?.navigateToAlert(message: error.localizedDescription)
                completion(false)
            case .unknown:
                self?.navigateToAlert(message: "Unknown error occurred")
                completion(false)
            }
        }
    }
    
    func nameIsChanged(newName: String) -> Bool {
        let oldname = user?.userName ?? ""
        return nameIsChanged(newName: newName, oldName: oldname)
    }
    
    private func nameIsChanged(newName: String, oldName: String) -> Bool {
        (newName != oldName) && (newName.isEmpty != true)
    }
    
    func optionsAreValid(_ optionSwitches: [OptionSwitch]) -> Bool {
        var areValid = true

        optionSwitches.forEach { optionSwitch in
            if let optionName = OptionDataName(rawValue: optionSwitch.optionName) {
                if optionIsValid(optionName: optionName, value: optionSwitch.optionValue) == true {
                    optionSwitch.setNormalState()
                } else {
                    optionSwitch.setErrorState()
                    areValid = false
                }
            }
        }

        return areValid
    }
    
    func optionIsValid(optionName: OptionDataName, value: String?) -> Bool {
        guard let value, let valueDouble = Double(value) else { return false }
        
        if valueDouble <= Constants.Validation.minValue {
            return false
        }
        
        switch optionName {
        case .height:
            return valueDouble <= Constants.Validation.maxHeight
        case .weight:
            return valueDouble <= Constants.Validation.maxWeight
        default:
            return valueDouble <= Constants.Validation.maxValue
        }
    }

    func prepareOptionsForEditing(_ optionSwitches: [OptionSwitch]) {
        var newSelectedOptions = [OptionData]()
        
        optionSwitches.forEach { optionSwitch in
            guard let optionName = OptionDataName(rawValue: optionSwitch.optionName) else { return }
            
            let value = Double(optionSwitch.optionValue ?? "") ?? 0.0
            let isShown = optionSwitch.optionSwitch.isOn
            let currentTimestamp = Int(Date().timeIntervalSince1970)
            let existingOption = user?.selectedOptions.first { $0.optionName == optionName }
            
            if var option = existingOption {
                handleExistingOption(&option,
                                     value: value,
                                     currentTimestamp: currentTimestamp,
                                     isShown: isShown)
                newSelectedOptions.append(option)
            } else {
                let newOption = OptionData(optionName: optionName,
                                           valueArray: [value],
                                           dateArray: [currentTimestamp],
                                           isShown: isShown)
                newSelectedOptions.append(newOption)
            }
        }
        selectedOptions = newSelectedOptions
    }
    
    func handleExistingOption(_ option: inout OptionData, value: Double, currentTimestamp: Int, isShown: Bool) {
        if let lastValue = option.valueArray.last, let lastValue, let lastTimestamp = option.dateArray.last {
            if lastValue != value {
                if currentTimestamp - lastTimestamp > Constants.minUpdateInterval {
                    option.valueArray.append(value)
                    option.dateArray.append(currentTimestamp)
                    let changedValue = value - lastValue
                    if abs(changedValue) >= Constants.minError {
                        option.changedValue = changedValue
                    }
                } else {
                    updateLastValueAndTimestamp(&option, value: value, currentTimestamp: currentTimestamp)
                }
            }
            option.isShown = isShown
        } else if let wasShown = option.isShown, wasShown != isShown {
            option.isShown = isShown
        }
    }

    private func updateLastValueAndTimestamp(_ option: inout OptionData, value: Double, currentTimestamp: Int) {
        option.valueArray.removeLast()
        let newLastValue = option.valueArray.last
        
        option.valueArray.append(value)
        option.dateArray.removeLast()
        option.dateArray.append(currentTimestamp)
        
        if let newLastValue = newLastValue, let newLastValue {
            let changedValue = value - newLastValue
            if abs(changedValue) >= Constants.minError {
                option.changedValue = changedValue
            }
        }
    }
    
    func navigateToHome() {
        coordinator?.navigateToHome()
    }
    
    func filterAndUpdateOptions(with selectedOptionNames: [OptionDataName]) {
        selectedOptions = selectedOptions.filter { selectedOptionNames.contains($0.optionName) }

        for optionName in selectedOptionNames {
            if !selectedOptions.contains(where: { $0.optionName == optionName }) {
                let newOption = OptionData(optionName: optionName, valueArray: [], dateArray: [])
                selectedOptions.append(newOption)
            }
        }
    }
    
    func selectedOptionsChanged() -> Bool {
        selectedOptions != user?.selectedOptions
    }
    
    func navigateToAlert(message: String) {
        let icon = UIImage(named: "customCircleCheckmarkSelected")
        let alertContent = AlertContent(alertType: .noButtons, message: message, icon: icon)
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
    func navigateToOptions() {
        let selectedOptionNames = selectedOptions.map { $0.optionName }
        coordinator?.navigateToOptions(selectedOptionNames: selectedOptionNames)
    }
    
    func navigateToDeleteAccount() {
        coordinator?.navigateToDeleteAccount()
    }
    
}
