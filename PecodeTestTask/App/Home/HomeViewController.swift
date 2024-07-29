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
        enum CollectionView {
            static let cellHeight: CGFloat = 104
            static let minimumLineSpacing: CGFloat = 24
        }
    }
    
    var viewModel: HomeViewModel?
    private var superheroName: String?

    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var optionsCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        loadUserData()
        
        optionsCollectionView.dataSource = self
        optionsCollectionView.delegate = self
    }
    
    static func instantiate() -> HomeViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.home, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.homeViewController) as! HomeViewController
    }
    
    private func loadUserData() {
        viewModel?.fetchUser { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                print("Error: \(errorMessage)")
            }
            self?.setupUI()
            self?.setProfileImage()
            self?.setupActions()
            self?.optionsCollectionView.reloadData()
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.optionsToShow.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionCell.identifier, for: indexPath) as? OptionCollectionCell,
              let option = viewModel?.optionsToShow[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.configure(with: option)
        
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = Constants.CollectionView.cellHeight
        
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.CollectionView.minimumLineSpacing
    }

}

extension HomeViewController: ProfileViewControllerDelegate {
    func profileDidUpdate() {
        loadUserData()
    }
}
