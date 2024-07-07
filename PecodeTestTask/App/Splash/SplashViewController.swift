//
//  SplashViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.07.2024.
//

import UIKit

class SplashViewController: UIViewController {

    @IBOutlet weak var chooseHeroLabel: UILabel!
    @IBOutlet weak var supermanButton: CustomButton!
    @IBOutlet weak var supergirlButton: CustomButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseHeroLabel.font = UIFont(name: "Saira-Regular", size: 16)
    }

    static func instantiate() -> SplashViewController? {
        let storyboard = UIStoryboard(name: StoryboardConstants.splash, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
    }
}
