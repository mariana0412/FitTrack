//
//  HomeViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

class HomeViewController: BaseViewController {
    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func instantiate() -> HomeViewController? {
        let storyboard = UIStoryboard(name: "Home", bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
    }
}
