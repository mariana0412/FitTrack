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
    private let selectedOptionNames: [OptionDataName]
    
    init(navigationController: UINavigationController, selectedOptionNames: [OptionDataName]) {
        self.navigationController = navigationController
        self.selectedOptionNames = selectedOptionNames
    }
    
    func start() {
        let optionsViewController = OptionsViewController.instantiate()
        optionsViewController.viewModel = OptionsViewModel(coordinator: self, 
                                                           selectedOptionNames: selectedOptionNames)
        
        optionsViewController.transitioningDelegate = popupTransitioningDelegate
        optionsViewController.modalPresentationStyle = .custom
        
        navigationController.present(optionsViewController, animated: true)
        
    }
    
    func navigateToProfile(with options: [OptionDataName]) {
        delegate?.didSelectOptions(options)
        navigateToProfile()
    }
    
    func navigateToProfile() {
        navigationController.dismiss(animated: true)
    }
    
}
