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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> DeleteAccountViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.deleteAccount, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.deleteAccountViewController) as! DeleteAccountViewController
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? "",
            backAction: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToProfile()
    }
    
}
