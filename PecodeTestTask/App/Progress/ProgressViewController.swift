//
//  ProgressViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

final class ProgressViewController: BaseViewController {
    var viewModel: ProgressViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadOptions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ProgressViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.progress, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.progressViewController) as! ProgressViewController
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let navigationButtons = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? ""
        )
    }
    
    private func loadOptions() {
        viewModel?.fetchUser { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                print("Error: \(errorMessage)")
            }
            self?.setupUI()
        }
    }
    
    private func setupUI() {
        
    }
    
}
