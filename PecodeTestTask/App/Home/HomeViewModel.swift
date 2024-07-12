//
//  HomeViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    private(set) var heroName: String = ""
    private(set) var userName: String = ""
    private(set) var sex: String = ""
    private(set) var backgroundImageName: String = ""
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    func fetchUserDetails(completion: @escaping (String?) -> Void) {
        FirebaseService.shared.getUser { [weak self] response, registrationData in
            switch response {
            case .success:
                if let user = registrationData {
                    self?.userName = user.userName
                    self?.sex = user.sex ?? ""
                    self?.heroName = user.sex == "male" ? "Superman" : "Supergirl"
                    self?.backgroundImageName = user.sex == "male" ? "backgroundImageMan" : "backgroundImageGirl"
                }
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred while fetching user details")
            }
        }
    }

}
