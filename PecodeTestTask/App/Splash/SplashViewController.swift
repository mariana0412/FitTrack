//
//  SplashViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.07.2024.
//

import UIKit

class SplashViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let chooseHeroLabelFontName = "Saira-Regular"
            static let chooseHeroLabelFontSize: CGFloat = 16.0
        }
        
        enum Overlay {
            static let supermanImageOpacity: CGFloat = 0.3
            static let supergirlImageOpacity: CGFloat = 0.3
        }
        
        enum Gradient {
            static let supermanColors: [CGColor] = [
                UIColor.black.withAlphaComponent(0.3).cgColor,
                UIColor.black.cgColor
            ]
            static let supermanLocations: [NSNumber] = [0.5, 1.0]
            
            static let supergirlColors: [CGColor] = [
                UIColor.black.cgColor,
                UIColor.black.withAlphaComponent(0.3).cgColor
            ]
            static let supergirlLocations: [NSNumber] = [0.0, 0.5]
        }
    }
    
    var viewModel: SplashViewModel?
    
    @IBOutlet private weak var superheroLabel: UILabel!
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
    
    static func instantiate() -> SplashViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.splash, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.splashViewController) as! SplashViewController
    }
    
    @objc private func supermanButtonTapped() {
        updateUserSex(sex: .male)
    }
    
    @objc private func supergirlButtonTapped() {
        updateUserSex(sex: .female)
    }
    
    private func updateUserSex(sex: UserSex) {
        disableButtons()
        
        viewModel?.updateUserSex(sex: sex) { [weak self] errorMessage in
            self?.enableButtons()
            
            if let errorMessage = errorMessage {
                self?.view.showCustomAlert(message: errorMessage)
            }
        }
    }
    
    private func disableButtons() {
        supermanButton.isEnabled = false
        supergirlButton.isEnabled = false
        supermanButton.backgroundColor = UIColor.primaryWhite
        supergirlButton.backgroundColor = UIColor.primaryWhite
    }
    
    private func enableButtons() {
        supermanButton.isEnabled = true
        supergirlButton.isEnabled = true
        supermanButton.backgroundColor = UIColor.primaryYellow
        supergirlButton.backgroundColor = UIColor.primaryYellow
    }
    
    private func setupUI() {
        self.navigationItem.hidesBackButton = true
        
        superheroLabel.text = viewModel?.superheroText
        superheroLabel.font = Fonts.futuraBold
        superheroLabel.textColor = .primaryYellow
        
        chooseHeroLabel.text = viewModel?.chooseHeroText
        chooseHeroLabel.font = Fonts.sairaRegular16
        chooseHeroLabel.textColor = .primaryWhite
        
        supermanButton.titleLabel?.text = viewModel?.supermanButtonText
        supermanButton.titleLabel?.font = Fonts.sairaRegular18
        
        supergirlButton.titleLabel?.text = viewModel?.supergirlButtonText
        supergirlButton.titleLabel?.font = Fonts.sairaRegular18
        
        OverlayUtils.addDarkOverlay(to: supermanImage,
                                    color: UIColor.black,
                                    opacity: Constants.Overlay.supermanImageOpacity)
        OverlayUtils.addDarkOverlay(to: supergirlImage, 
                                    color: UIColor.black,
                                    opacity: Constants.Overlay.supergirlImageOpacity)
        
        GradientUtils.addGradientLayer(to: supermanImage,
                                       colors: Constants.Gradient.supermanColors,
                                       locations: Constants.Gradient.supermanLocations)
        GradientUtils.addGradientLayer(to: supergirlImage, 
                                       colors: Constants.Gradient.supergirlColors,
                                       locations: Constants.Gradient.supergirlLocations)
    }
    
    private func setupActions() {
        supermanButton.addTarget(self, action: #selector(supermanButtonTapped), for: .touchUpInside)
        supergirlButton.addTarget(self, action: #selector(supergirlButtonTapped), for: .touchUpInside)
    }
    
}
