//
//  SplashViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 07.07.2024.
//

import FirebaseAuth

class SplashViewModel {
    
    enum UserSex: String {
        case male = "male"
        case female = "female"
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
                self?.coordinator?.navigateToHome()
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred.")
            }
        }
    }
}
