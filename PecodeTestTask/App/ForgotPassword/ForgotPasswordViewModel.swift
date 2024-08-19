//
//  ForgotPasswordViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.07.2024.
//

class ForgotPasswordViewModel {
    private var coordinator: ForgotPasswordCoordinator?
    
    let superheroText = "SUPERHERO"
    let forgotPasswordText = "Forgot Password"
    let emailText = "Email"
    let emailPlaceholderText = "Enter email"
    let explanationText = "Enter the email address associated with your account and we'll send you a form to reset your password."
    let continueButtonText = "Continue"
    let backToLogintButtonText = "Back to login"
    let alertSuccessMessage = "The form has been sent to your e-mail"
    let alertErrorMessage = "Please check the email you entered. Something seems to be wrong."
    let alertOkButtonText = "Ok"
    let alertCancelButtonText = "Cancel"
    
    init(coordinator: ForgotPasswordCoordinator?) {
        self.coordinator = coordinator
    }
    
    func resetPassword(email: String, completion: @escaping (String?) -> Void) {
        FirebaseService.shared.resetPassword(email: email) { [weak self] response in
            switch response {
            case .success:
                self?.showSuccessAlert()
                completion(nil)
            case .failure(let error):
                self?.showErrorAlert()
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred.")
            }
        }
    }
    
    func navigateToLogin() {
        coordinator?.navigateToLogin()
    }
    
    private func showErrorAlert() {
        let alertContent = AlertContent(alertType: .twoButtons,
                                        message: alertErrorMessage,
                                        okButtonTitle: alertOkButtonText,
                                        cancelButtonTitle: alertCancelButtonText,
                                        cancelClickedAction: { [weak self] in self?.navigateToLogin()
                                        })
        navigateToAlert(alertContent: alertContent)
    }
    
    private func showSuccessAlert() {
        let alertContent = AlertContent(alertType: .oneButton,
                                        message: alertSuccessMessage,
                                        okButtonTitle: alertOkButtonText,
                                        okClickedAction: { [weak self] in
                                            self?.navigateToLogin()
                                        })
        navigateToAlert(alertContent: alertContent)
    }
    
    private func navigateToAlert(alertContent: AlertContent) {
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
}
