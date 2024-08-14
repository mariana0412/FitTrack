//
//  CalculatorViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//

import UIKit

final class CalculatorViewController: BaseViewController {
    
    var viewModel: CalculatorViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("type: ", viewModel?.type)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> CalculatorViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.calculator, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.calculatorViewController) as! CalculatorViewController
    }
   
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationBarTitle ?? "",
            backAction: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToCalculatorSelection()
    }
    
}
