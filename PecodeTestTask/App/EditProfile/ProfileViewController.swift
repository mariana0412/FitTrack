//
//  EditProfileController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 20.07.2024.
//

import UIKit

class ProfileViewController: BaseViewController {
    var viewModel: ProfileViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    static func instantiate() -> ProfileViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.profile, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.profileViewController) as! ProfileViewController
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "Profile"
        titleLabel.font = Fonts.sairaMedium18
        titleLabel.textColor = .primaryWhite
        navigationItem.titleView = titleLabel
        
        
        let backButton = UIButton(type: .system)
        
        let chevronLeft = UIImage(systemName: "chevron.left")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 13, weight: .medium))
        let tintedChevronLeft = chevronLeft?.withTintColor(.primaryYellow, renderingMode: .alwaysOriginal)
        backButton.setImage(tintedChevronLeft, for: .normal)
        
        backButton.setTitle("  Back", for: .normal)
        backButton.titleLabel?.font = Fonts.sairaMedium18
        backButton.setTitleColor(.primaryYellow, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.leftBarButtonItem = backBarButtonItem
        
        
        let saveButton = UIButton(type: .custom)
        saveButton.setTitle("Save", for: .normal)
        saveButton.titleLabel?.font = Fonts.sairaMedium18
        saveButton.setTitleColor(.secondaryGray, for: .normal)
        saveButton.setTitleColor(.primaryYellow, for: .highlighted)
        saveButton.setTitleColor(.primaryYellow, for: .selected)
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToHome()
    }
    
    @objc private func saveButtonTapped() {
        
    }
    
}
