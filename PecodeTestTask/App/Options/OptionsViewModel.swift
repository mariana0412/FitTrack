//
//  OptionsViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

class OptionsViewModel {
    
    let selectOptionText = "Select Option"
    let cancelButtonText = "Cancel"
    let selectButtonText = "Select"
    
    private var coordinator: OptionsCoordinator?
    
    let options = OptionDataName.allCases
    var selectedOptionNames: [OptionDataName]
    
    init(coordinator: OptionsCoordinator?, selectedOptionNames: [OptionDataName]) {
        self.coordinator = coordinator
        self.selectedOptionNames = selectedOptionNames
    }
    
    func addOption(_ newOption: OptionDataName) {
        if !selectedOptionNames.contains(newOption) {
            selectedOptionNames.append(newOption)
        }
    }
    
    func removeOption(_ option: OptionDataName) {
        if let index = selectedOptionNames.firstIndex(of: option) {
            selectedOptionNames.remove(at: index)
        }
    }
    
    func isOptionSelected(_ option: OptionDataName) -> Bool {
        return selectedOptionNames.contains(option)
    }
    
    func handleOptionSelection(for option: OptionDataName) {
        if isOptionSelected(option) {
            removeOption(option)
        } else {
            addOption(option)
        }
    }
    
    func navigateToProfileWithChanges() {
        coordinator?.navigateToProfile(with: selectedOptionNames)
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
}
