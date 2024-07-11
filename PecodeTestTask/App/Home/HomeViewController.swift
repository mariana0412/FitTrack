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
            static let labelFontName = "Saira-Regular"
            static let superheroLabelFontSize: CGFloat = 24.0
            static let nameLabelFontSize: CGFloat = 16.0
        }
    }
    
    var viewModel: HomeViewModel?
    private var superheroName: String?

    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserData()
    }

    static func instantiate() -> HomeViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.home, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.homeViewController) as! HomeViewController
    }
    
    private func loadUserData() {
        viewModel?.fetchUserDetails { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                let alert = AlertUtils.createAlert(message: errorMessage)
                self?.present(alert, animated: true, completion: nil)
            } else {
                self?.setupUI()
            }
        }
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        superheroLabel.text = viewModel.heroName
        superheroLabel.font = UIFont(name: Constants.Layout.labelFontName, 
                                     size: Constants.Layout.superheroLabelFontSize)
        
        nameLabel.text = viewModel.userName
        nameLabel.font = UIFont(name: Constants.Layout.labelFontName,
                                size: Constants.Layout.nameLabelFontSize)
    
        updateBackgroundImage(named: viewModel.backgroundImageName)
    }
    
}
