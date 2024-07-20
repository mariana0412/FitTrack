//
//  HomeViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    private(set) var userSex: UserSex
    private(set) var heroName: String = ""
    private(set) var userName: String = ""
    private(set) var backgroundImageName = ""
    
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
                    self?.userName = user.userName
                }
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred while fetching user details")
            }
        }
    }
    
    func navigateToProfile() {
        print(coordinator == nil)
        coordinator?.navigateToProfile()
    }

}
