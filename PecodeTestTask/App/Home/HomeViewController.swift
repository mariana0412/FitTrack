//
//  HomeViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class HomeViewController: BaseViewController {
    var viewModel: HomeViewModel?
    private var superheroName: String?

    @IBOutlet private weak var superheroLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    static func instantiate() -> HomeViewController? {
        let storyboard = UIStoryboard(name: StoryboardConstants.home, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
    
    private func setupUI() {
        guard let viewModel = viewModel else { return }
        
        superheroLabel.text = viewModel.heroName
        superheroLabel.font = UIFont(name: Constants.Layout.superheroLabelFontName, size: Constants.Layout.superheroLabelFontSize)
    }
    
    private enum Constants {
        enum Layout {
            static let superheroLabelFontName = "Saira-Regular"
            static let superheroLabelFontSize: CGFloat = 24.0
        }
    }
}
