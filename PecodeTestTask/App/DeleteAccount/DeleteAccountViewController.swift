//
//  DeleteAccountViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

import UIKit

final class DeleteAccountViewController: BaseViewController {
    var viewModel: DeleteAccountViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> DeleteAccountViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.deleteAccount, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.deleteAccountViewController) as! DeleteAccountViewController
    }
    
}
