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
    
    func navigateToHome() {
        coordinator?.navigateToHome()
    }
}
