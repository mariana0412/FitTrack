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
            } else {
                self?.setupUI()
            }
        }
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        superheroLabel.text = viewModel.heroName
        superheroLabel.font = Fonts.sairaRegular24
        
        nameLabel.text = viewModel.userName
        nameLabel.font = Fonts.sairaRegular16
        
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = Constants.Layout.profileImageCornerRadius
        profileImage.layer.borderWidth = Constants.Layout.profileImageBorderWidth
        profileImage.layer.borderColor = Constants.Layout.profileImageBorderColor
        profileImage.image = UIImage(named: Constants.Layout.defaultProfileImageName)
    
        updateBackgroundImage(named: viewModel.backgroundImageName)
    }
    
}
