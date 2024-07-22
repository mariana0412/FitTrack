//
//  ProfileViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class ProfileViewModel {
    
    enum Texts {
        enum NavigationItem {
            static let leftBarButton = "Back"
            static let title = "Profile"
            static let rightBarButton = "Save"
        }
        
        static let name = "Name"
        static let namePlaceholder = "Enter Your Name"
        static let instruction = "Select an option to display on the main screen."
        static let addOptionsButton = "Add Options"
        static let defaultImageName = "noImage"
    }
    
    private var coordinator: ProfileCoordinator?
    
    private(set) var user: UserData?
    private(set) var backgroundImageName = ""
    
    init(coordinator: ProfileCoordinator, user: UserData) {
        self.coordinator = coordinator
        self.user = user
    
        self.backgroundImageName = (user.sex == .female) ? "backgroundImageGirl" : "backgroundImageMan"
    }
    
    func editProfile(newName: String, newImage: UIImage?, completion: @escaping (Bool) -> Void) {
        let newName = nameIsChanged(newName: newName) ? newName : nil
        
        var newImageData: Data?
        if let newImage {
            newImageData = newImage.compress(to: 1048487)
        }

        FirebaseService.shared.updateUserProfile(newName: newName, 
                                                 newImage: newImageData) { [weak self] response in
            switch response {
            case .success:
                self?.navigateToAlert(message: "Profile has been saved!")
                completion(true)
                self?.user?.userName = newName ?? ""
                self?.user?.profileImage = newImageData
            case .failure(let error):
                self?.navigateToAlert(message: error.localizedDescription)
                completion(false)
            case .unknown:
                self?.navigateToAlert(message: "Unknown error occurred")
                completion(false)
            }
        }
    }
    
    func nameIsChanged(newName: String) -> Bool {
        let oldname = user?.userName ?? ""
        return nameIsChanged(newName: newName, oldName: oldname)
    }
    
    private func nameIsChanged(newName: String, oldName: String) -> Bool {
        (newName != oldName) && (newName.isEmpty != true)
    }
    
    func navigateToHome() {
        coordinator?.navigateToHome()
    }
    
    func navigateToAlert(message: String) {
        let alertContent = AlertContent(message: message)
        coordinator?.navigateToAlert(alertContent: alertContent)
    }
    
}
