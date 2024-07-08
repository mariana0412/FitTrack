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
    @IBOutlet private weak var supermanImage: UIImageView!
    @IBOutlet private weak var supergirlImage: UIImageView!
    
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
        
        OverlayUtils.addDarkOverlay(to: supermanImage, color: UIColor.black, opacity: 0.3)
        OverlayUtils.addDarkOverlay(to: supergirlImage, color: UIColor.black, opacity: 0.3)
        
        let supermanGradientColors = [
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.cgColor
        ]
        let supermanGradientLocations = [0.5, 1.0]
        GradientUtils.addGradientLayer(to: supermanImage, colors: supermanGradientColors, locations: supermanGradientLocations)
        
        let supergirlGradientColors = [
            UIColor.black.cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor
        ]
        let supergirlGradientLocations = [0.0, 0.5]
        GradientUtils.addGradientLayer(to: supergirlImage, colors: supergirlGradientColors, locations: supergirlGradientLocations)
    }
    
    private func setupActions() {
        supermanButton.addTarget(self, action: #selector(supermanButtonTapped), for: .touchUpInside)
        supergirlButton.addTarget(self, action: #selector(supergirlButtonTapped), for: .touchUpInside)
    }
    
}
