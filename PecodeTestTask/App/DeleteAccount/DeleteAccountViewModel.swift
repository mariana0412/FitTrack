//
//  DeleteAccountViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

class DeleteAccountViewModel {
    
    let navigationItemTitle = "Delete account"
    let emailTextFieldLabel = "Email"
    let emailTextFieldPlaceholderText = "Enter email"
    let instructionText = "To delete your account, confirm your email."
    let deleteButtonText = "Delete"
    private(set) var backgroundImageName = ""
    
    private var coordinator: DeleteAccountCoordinator?
    
    init(coordinator: DeleteAccountCoordinator?, userSex: UserSex) {
        self.coordinator = coordinator
        self.backgroundImageName = (userSex == .female) ? "backgroundImageGirl" : "backgroundImageMan"
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
}
