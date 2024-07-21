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
    private(set) var profileImage: UIImage
    
    init(coordinator: ProfileCoordinator, user: UserData) {
        self.coordinator = coordinator
        self.user = user
    
        self.backgroundImageName = (user.sex == .female) ? "backgroundImageGirl" : "backgroundImageMan"
        
        if let profileImageData = user.profileImage {
            profileImage = UIImage(data: profileImageData) ?? UIImage()
        } else {
            profileImage = UIImage(named: Texts.defaultImageName) ?? UIImage()
        }
    }
    
    func navigateToHome() {
        coordinator?.navigateToHome()
    }
}
