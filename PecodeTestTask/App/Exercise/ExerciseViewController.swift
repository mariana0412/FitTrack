//
//  ExerciseViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

final class ExerciseViewController: BaseViewController {
    var viewModel: ExerciseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ExerciseViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.exercise, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.exerciseViewController) as! ExerciseViewController
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
        viewModel?.navigateToMuscles()
    }
    
}
