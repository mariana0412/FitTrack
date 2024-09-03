//
//  ActivityLevelCoordinator.swift
//  FitTrack
//
//  Created by Mariana Piz on 17.08.2024.
//

import UIKit

class ActivityLevelCoordinator: Coordinator {
    var navigationController: UINavigationController
    weak var delegate: ActivityLevelCoordinatorDelegate?
    private let popupTransitioningDelegate = PopupTransitioningDelegate()
    private let selectedActivityLevel: DailyCaloriesRateActivity?
    
    init(navigationController: UINavigationController, 
         selectedActivityLevel: DailyCaloriesRateActivity?) {
        self.navigationController = navigationController
        self.selectedActivityLevel = selectedActivityLevel
    }
    
    func start() {
        let activityLevelViewController = ActivityLevelViewController.instantiate()
        activityLevelViewController.viewModel = ActivityLevelViewModel(coordinator: self,
                                                           selectedActivityLevel: selectedActivityLevel)
        
        activityLevelViewController.transitioningDelegate = popupTransitioningDelegate
        activityLevelViewController.modalPresentationStyle = .custom
        
        navigationController.present(activityLevelViewController, animated: true)
        
    }
    
    func navigateToCalculator(with selectedActivityLevel: DailyCaloriesRateActivity?) {
        delegate?.didSelectActivityLevel(selectedActivityLevel)
        navigateToCalculator()
    }
    
    func navigateToCalculator() {
        navigationController.dismiss(animated: true)
    }
    
}
