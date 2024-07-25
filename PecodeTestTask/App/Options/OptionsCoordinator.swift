//
//  OptionsCoordinator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

import UIKit

class OptionsCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var delegate: OptionsCoordinatorDelegate?
    private let popupTransitioningDelegate = PopupTransitioningDelegate()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let optionsViewController = OptionsViewController.instantiate()
        optionsViewController.viewModel = OptionsViewModel(coordinator: self)
        
        optionsViewController.transitioningDelegate = popupTransitioningDelegate
        optionsViewController.modalPresentationStyle = .custom
        
        navigationController.present(optionsViewController, animated: true)
        
    }
    
    func navigateToProfile(with options: [OptionDataName]) {
        delegate?.didSelectOptions(options)
        navigationController.dismiss(animated: true)
    }
    
}
