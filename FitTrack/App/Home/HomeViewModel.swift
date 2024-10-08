//
//  HomeViewModel.swift
//  FitTrack
//
//  Created by Mariana Piz on 30.06.2024.
//

class HomeViewModel {
    private var coordinator: HomeCoordinator?
    private(set) var userSex: UserSex
    private(set) var heroName: String = ""
    private(set) var backgroundImageName = ""
    private(set) var user: UserData?
    private(set) var optionsToShow: [OptionData] = []
    
    init(coordinator: HomeCoordinator, userSex: UserSex) {
        self.coordinator = coordinator
        self.userSex = userSex
        if self.userSex.rawValue == "male" {
            self.heroName = "Superman"
            self.backgroundImageName = "backgroundImageMan"
        } else {
            self.heroName = "Supergirl"
            self.backgroundImageName = "backgroundImageGirl"
        }
    }
    
    func fetchUser(completion: @escaping (String?) -> Void) {
        FirebaseService.shared.getUser { [weak self] response in
            switch response {
            case .success(let registrationData):
                if let user = registrationData, let user = user {
                    self?.updateUserData(user: user)
                }
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred while fetching user details")
            }
        }
    }
    
    func updateUser(with user: UserData) {
        updateUserData(user: user)
    }
    
    private func updateUserData(user: UserData) {
        self.user = user
        self.optionsToShow = user.selectedOptions.filter { $0.isShown == true }
    }
    
    func navigateToProfile() {
        guard let user = user else { return }
        coordinator?.navigateToProfile(with: user)
    }
    
}
