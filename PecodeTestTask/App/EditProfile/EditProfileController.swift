//
//  EditProfileController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class EditProfileController: BaseViewController {
    var viewModel: EditProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> EditProfileController {
        let storyboard = UIStoryboard(name: StoryboardConstants.editProfile, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.editProfileViewController) as! EditProfileController
    }
    
}
