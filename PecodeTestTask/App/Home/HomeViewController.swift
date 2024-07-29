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
            print("user: \(self?.viewModel?.user?.selectedOptions)")
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
        return viewModel?.user?.selectedOptions.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionCell", for: indexPath) as? OptionCollectionCell,
              let option = viewModel?.user?.selectedOptions[indexPath.item] else {
            return UICollectionViewCell()
        }
        cell.configure(with: option)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height: CGFloat = 104
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }

}

extension HomeViewController: ProfileViewControllerDelegate {
    
    func profileDidUpdate() {
        loadUserData()
    }
}

class OptionCollectionCell: UICollectionViewCell {
    
    enum Constants {
        static let identifier = "OptionCollectionCell"
    }

    @IBOutlet weak var optionName: UILabel!
    @IBOutlet weak var optionValue: UILabel!
    @IBOutlet weak var optionMeasure: UILabel!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var changedValue: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.cornerRadius = 10
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.cgColor
        containerView.layer.masksToBounds = true

        circleView.layer.cornerRadius = circleView.frame.size.width / 2
        circleView.clipsToBounds = true
    }
    
    func configure(with option: OptionData) {
        optionName.text = option.optionName.rawValue
        if let value = option.valueArray.last, let value {
            optionValue.text = "\(value)"
        }
        
        optionMeasure.text = option.optionName.metricValue
        
        if let change = option.changedValue {
            if change > 0 {
                changedValue.text = "+\(change)"
                circleView.backgroundColor = UIColor.lightRed
            } else {
                changedValue.text = "-\(change)"
                circleView.backgroundColor = UIColor.lightGreen
            }
        } else {
            changedValue.text = ""
            circleView.backgroundColor = UIColor.clear
        }
    }
}
