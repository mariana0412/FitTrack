//
//  MusclesViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

final class MusclesViewController: BaseViewController {
    var viewModel: MusclesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadExercises {}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> MusclesViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.muscles, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.musclesViewController) as! MusclesViewController
    }
   
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationBarTitle ?? "",
            rightButtonName: viewModel?.navigationBarRightButtonTitle,
            rightButtonAction: #selector(resetButtonTapped)
        )
    }
    
    @objc private func resetButtonTapped() {
        
    }
    
}
