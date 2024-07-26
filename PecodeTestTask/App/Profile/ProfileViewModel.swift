//
//  ProfileViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class ProfileViewModel {
    
    enum Constants {
        enum Texts {
            static let navigationItemTitle = "Profile"
            static let name = "Name"
            static let namePlaceholder = "Enter Your Name"
            static let instruction = "Select an option to display on the main screen."
            static let addOptionsButton = "Add Options"
            static let defaultImageName = "noImage"
        }
        
        enum Validation {
            static let maxHeight: Double = 300
            static let maxWeight: Double = 300
            static let maxValue: Double = 100
            static let minValue: Double = 0
        }
        
        static let maxNumberOfBytesInData = 1048487
    }
    
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
        
        let newOptions = selectedOptionsChanged() ? selectedOptions : nil

        FirebaseService.shared.updateUserProfile(newName: newName, 
                                                 newImage: newImageData, newOptions: newOptions) { [weak self] response in
            switch response {
            case .success(let updatedUser):
                self?.navigateToAlert(message: "Profile has been saved!")
                completion(true)
                if let user = updatedUser {
                    self?.user = user
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
    
    func validateOption(optionName: OptionDataName, value: String?) -> Bool {
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
    
    func navigateToHome() {
        coordinator?.navigateToHome()
    }
    
    func filterAndUpdateOptions(with selectedOptionNames: [OptionDataName]) {
        selectedOptions = selectedOptions.filter { selectedOptionNames.contains($0.optionName) }

        for optionName in selectedOptionNames {
            if !selectedOptions.contains(where: { $0.optionName == optionName }) {
                let newOption = OptionData(optionName: optionName)
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
    
}
