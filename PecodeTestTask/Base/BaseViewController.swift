//
//  BaseViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class BaseViewController: UIViewController {
    
    private enum Constants {
        enum Images {
            static let backgroundImageName = "backgroundImageMan"
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
    
    private var backgroundImageView: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        setBackgroundImage(named: Constants.Images.backgroundImageName)
    }
    
    func updateBackgroundImage(named imageName: String) {
        guard let backgroundImageView = backgroundImageView else { return }
        guard let backgroundImage = UIImage(named: imageName) else {
            print("Error: Image \(imageName) not found.")
            return
        }
        
        backgroundImageView.image = backgroundImage
    }
    
    private func setBackgroundImage(named imageName: String) {
        guard let backgroundImage = UIImage(named: imageName) else {
            print("Error: Image \(imageName) not found.")
            return
        }
        
        backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView?.contentMode = .scaleAspectFill
        backgroundImageView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let backgroundImageView = backgroundImageView else { return }
        
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

}
