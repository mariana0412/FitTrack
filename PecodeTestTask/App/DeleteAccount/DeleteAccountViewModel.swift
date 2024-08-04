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
    let alertErrorMessage = "Are you sure you want to delete your account?"
    let alertOkButtonText = "Delete"
    let alertCancelButtonText = "Cancel"
    
    private var coordinator: DeleteAccountCoordinator?
    
    init(coordinator: DeleteAccountCoordinator?, userSex: UserSex) {
        self.coordinator = coordinator
        self.backgroundImageName = (userSex == .female) ? "backgroundImageGirl" : "backgroundImageMan"
    }
    
    func emailIsValid(enteredEmail: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserEmail = FirebaseService.shared.getCurrentUserEmail() else {
            completion(false)
            return
        }
        completion(enteredEmail == currentUserEmail)
    }
    
    func navigateToAlert(disableAction: @escaping () -> Void) {
        let alertContent = AlertContent(alertType: .twoButtons,
                                        message: alertErrorMessage,
                                        okButtonTitle: alertOkButtonText,
                                        cancelButtonTitle: alertCancelButtonText,
                                        okClickedAction: { [weak self] in
                                            disableAction()
                                        })
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
}
