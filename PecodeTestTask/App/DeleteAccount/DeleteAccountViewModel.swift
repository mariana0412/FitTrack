//
//  DeleteAccountViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

import Foundation
import FirebaseAuth

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
    
    func navigateToAlert(disableDeleteButton: @escaping () -> Void) {
        let alertContent = AlertContent(alertType: .twoButtons,
                                        message: alertErrorMessage,
                                        okButtonTitle: alertOkButtonText,
                                        cancelButtonTitle: alertCancelButtonText,
                                        okClickedAction: { [weak self] in
                                            disableDeleteButton()
                                            self?.deleteUser()
                                        })
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
    private func deleteUser() {
        FirebaseService.shared.deleteUser { [weak self] response in
            switch response {
            case .success:
                self?.navigateToSignup()
            case .failure(let error):
                self?.handleFailure(error: error)
                print(error.localizedDescription)
            case .unknown:
                print("Unknown error occurred while deleting account.")
            }
        }
    }
    
    private func handleFailure(error: Error) {
        let nsError = error as NSError
        let errorMessage = "Error deleting account: \(error.localizedDescription)"
        
        switch nsError.code {
        case AuthErrorCode.requiresRecentLogin.rawValue:
            let alertContent = AlertContent(alertType: .twoButtons,
                                            message: errorMessage,
                                            okButtonTitle: "Log out",
                                            cancelButtonTitle: "Cancel",
                                            okClickedAction: {
                                                self.signOut()
                                            })
            self.navigateToAlert(alertContent: alertContent)
        default:
            let alertContent = AlertContent(alertType: .noButtons,
                                            message: errorMessage)
            self.navigateToAlert(alertContent: alertContent)
        }
    }
    
    private func signOut() {
        FirebaseService.shared.signOut { [weak self] response in
            switch response {
            case .success:
                self?.navigateToLogin()
            case .failure(let signOutError):
                print("Error signing out: \(signOutError.localizedDescription)")
            case .unknown:
                print("Unknown error occurred while signing out.")
            }
        }
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
    private func navigateToSignup() {
        coordinator?.navigateToSignup()
    }
    
    private func navigateToLogin() {
        coordinator?.navigateToLogin()
    }
    
    private func navigateToAlert(alertContent: AlertContent) {
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
}
