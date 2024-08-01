//
//  ChartViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

import UIKit

final class ChartViewController: BaseViewController {
    var viewModel: ChartViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ChartViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.chart, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.chartViewController) as! ChartViewController
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
        viewModel?.navigateToProgress()
    }
    
}
