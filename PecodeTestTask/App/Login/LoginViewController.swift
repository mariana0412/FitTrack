//
//  LoginViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 13.07.2024.
//

import UIKit

final class LoginViewController: BaseViewController {
    var viewModel: LoginViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> LoginViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.login, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.loginViewController) as! LoginViewController
    }
}
