//
//  HomeViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let profileImageCornerRadius: CGFloat = 8
            static let profileImageBorderWidth: CGFloat = 1
            static let profileImageBorderColor: CGColor = UIColor.primaryYellow.cgColor
            static let defaultProfileImageName = "profileImage"
        }
    }
    
    var viewModel: HomeViewModel?
    private var superheroName: String?

    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        loadUserData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
    }
    
    static func instantiate() -> HomeViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.home, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.homeViewController) as! HomeViewController
    }
    
    private func loadUserData() {
        viewModel?.fetchUser { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                self?.view.showCustomAlert(message: errorMessage)
            }
            self?.setupUI()
            self?.setProfileImage()
            self?.setupActions()
        }
    }
    
    private func setupUI() {
        self.navigationItem.hidesBackButton = true
        
        guard let viewModel = viewModel else { return }
        
        updateBackgroundImage(named: viewModel.backgroundImageName)
        
        superheroLabel.text = viewModel.heroName
        superheroLabel.font = Fonts.sairaRegular24
        
        nameLabel.text = viewModel.userName
        nameLabel.font = Fonts.sairaRegular16
    }
    
    private func setProfileImage() {
        if let profileImageData = viewModel?.user?.profileImage {
            profileImage.setImageWithBorder(image: UIImage(data: profileImageData))
        } else {
            profileImage.image = UIImage(named: Constants.Layout.defaultProfileImageName)
        }
    }
    
    private func setupActions() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func profileImageTapped() {
        viewModel?.navigateToProfile()
    }
    
}
