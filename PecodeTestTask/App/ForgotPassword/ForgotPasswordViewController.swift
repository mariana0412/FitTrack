//
//  ForgotPasswordViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.07.2024.
//

import UIKit

class ForgotPasswordViewController: BaseViewController {
    var viewModel: ForgotPasswordViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> ForgotPasswordViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.forgotPassword, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.forgotPasswordViewController) as! ForgotPasswordViewController
    }
}
