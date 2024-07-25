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
    private(set) var selectedOptions = Set<OptionDataName>()
    
    init(coordinator: OptionsCoordinator?) {
        self.coordinator = coordinator
    }
    
    func addOption(_ newOption: OptionDataName) {
        selectedOptions.insert(newOption)
    }
    
    func removeOption(_ option: OptionDataName) {
        selectedOptions.remove(option)
    }
    
    func isOptionSelected(_ option: OptionDataName) -> Bool {
        return selectedOptions.contains(option)
    }
    
    func handleOptionSelection(for option: OptionDataName) {
        if isOptionSelected(option) {
            removeOption(option)
        } else {
            addOption(option)
        }
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
}
