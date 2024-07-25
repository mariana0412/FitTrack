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
    
    init(coordinator: OptionsCoordinator?) {
        self.coordinator = coordinator
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
}
