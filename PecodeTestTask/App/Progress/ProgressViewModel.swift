//
//  ProgressViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

class ProgressViewModel {
    
    let noOptionsText = "Options are not selected. To display them, add them to your profile."
    let navigationItemTitle = "Progress"
    
    private var coordinator: ProgressCoordinator?
    var options: [OptionData] = []
    
    init(coordinator: ProgressCoordinator?) {
        self.coordinator = coordinator
    }
    
    func fetchUser(completion: @escaping (String?) -> Void) {
        FirebaseService.shared.getUser { [weak self] response in
            switch response {
            case .success(let userData):
                if let user = userData, let user {
                    self?.options = user.selectedOptions
                }
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            case .unknown:
                completion("Unknown error occurred while fetching user details")
            }
        }
    }
    
    func navigateToChart(optionData: OptionData) {
        coordinator?.navigateToChart(optionData: optionData)
    }
    
}
