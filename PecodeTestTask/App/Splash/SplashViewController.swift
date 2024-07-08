//
//  SplashViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.07.2024.
//

import UIKit

class SplashViewController: UIViewController {
    var viewModel: SplashViewModel?
    
    @IBOutlet private weak var chooseHeroLabel: UILabel!
    @IBOutlet private weak var supermanButton: CustomButton!
    @IBOutlet private weak var supergirlButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
    }
    
    static func instantiate() -> SplashViewController? {
        let storyboard = UIStoryboard(name: StoryboardConstants.splash, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
    }
    
    @objc private func supermanButtonTapped() {
        viewModel?.buttonTapped(with: "Superman")
    }
    
    @objc private func supergirlButtonTapped() {
        viewModel?.buttonTapped(with: "Supergirl")
    }
    
    private func setupUI() {
        chooseHeroLabel.font = UIFont(name: "Saira-Regular", size: 16)
    }
    
    private func setupActions() {
        supermanButton.addTarget(self, action: #selector(supermanButtonTapped), for: .touchUpInside)
        supergirlButton.addTarget(self, action: #selector(supergirlButtonTapped), for: .touchUpInside)
    }
    
}
