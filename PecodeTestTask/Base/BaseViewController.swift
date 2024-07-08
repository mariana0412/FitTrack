//
//  BaseViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackgroundImage(named: Constants.Images.backgroundImageName, alpha: Constants.Layout.backgroundImageAlpha)
    }
    
    private func setBackgroundImage(named imageName: String, alpha: CGFloat) {
        guard let backgroundImage = UIImage(named: imageName) else {
            print("Error: Image \(imageName) not found.")
            return
        }
        
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = alpha
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(backgroundImageView)
        view.sendSubviewToBack(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        view.layoutIfNeeded()
        
        GradientUtils.addGradientLayer(to: backgroundImageView,
                                       colors: Constants.Gradient.colors,
                                       locations: Constants.Gradient.locations)
    }
    
    private enum Constants {
        enum Layout {
            static let backgroundImageAlpha: CGFloat = 1.0
        }
        
        enum Images {
            static let backgroundImageName = "backgroundImage"
        }
        
        enum Gradient {
            static let colors: [CGColor] = [
                UIColor.black.withAlphaComponent(0.3).cgColor,
                UIColor.black.withAlphaComponent(0.8).cgColor,
                UIColor.black.cgColor
            ]
            static let locations: [NSNumber] = [0.0, 0.4, 0.75]
        }
    }

}
