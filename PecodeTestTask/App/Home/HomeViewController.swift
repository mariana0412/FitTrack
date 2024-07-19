//
//  HomeViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    var viewModel: HomeViewModel?
    private var superheroName: String?

    @IBOutlet private weak var superheroLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
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
    
        updateBackgroundImage(named: viewModel.backgroundImageName)
    }
    
}
