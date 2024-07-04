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
        setBackgroundImage(named: "backgroundImage", alpha: 0.5)
    }
    
    func setBackgroundImage(named imageName: String, alpha: CGFloat) {
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
    }
    
}
