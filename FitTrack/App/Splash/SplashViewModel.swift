//
//  SplashViewModel.swift
//  FitTrack
//
//  Created by Mariana Piz on 07.07.2024.
//

import FirebaseAuth

class SplashViewModel {
    
    private enum Constants {
        static let alertIconName = "exclamationmark.triangle"
    }
    
    private var coordinator: SplashCoordinator?
    
    let superheroText = "SUPERHERO"
    let chooseHeroText = "choose a hero"
    let supermanButtonText = "SUPERMAN"
    let supergirlButtonText = "SUPERGIRL"
    
    init(coordinator: SplashCoordinator?) {
        self.coordinator = coordinator
    }
    
    func updateUserSex(sex: UserSex, completion: @escaping (String?) -> Void) {
        FirebaseService.shared.updateUserSex(sex: sex.rawValue) { [weak self] response in
            switch response {
            case .success:
                self?.navigateToHome(userSex: sex)
                completion(nil)
            case .failure(let error):
                self?.navigateToAlert(message: error.localizedDescription)
                completion(error.localizedDescription)
            case .unknown:
                self?.navigateToAlert(message: "Unknown error occurred.")
                completion("Unknown error occurred.")
            }
        }
    }
    
    func navigateToHome(userSex: UserSex) {
        coordinator?.navigateToHome(userSex: userSex)
    }
    
    func navigateToAlert(message: String) {
        let errorIcon = UIImage(systemName: Constants.alertIconName)
        let alertContent = AlertContent(alertType: .noButtons, message: message, icon: errorIcon)
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
}
