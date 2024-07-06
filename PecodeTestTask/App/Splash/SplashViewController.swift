//
//  SplashViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.07.2024.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func instantiate() -> SplashViewController? {
        let storyboard = UIStoryboard(name: StoryboardConstants.splash, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "SplashViewController") as? SplashViewController
    }
}
