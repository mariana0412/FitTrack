//
//  AlertCoordinator.swift
//  FitTrack
//
//  Created by Mariana Piz on 22.07.2024.
//

import UIKit

class AlertCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    private var alertContent: AlertContent
        
    init(navigationController: UINavigationController, alertContent: AlertContent) {
        self.navigationController = navigationController
        self.alertContent = alertContent
    }
    
    func start() {
        let alertViewController = AlertViewController.instantiate()
        let alertViewModel = AlertViewModel(coordinator: self, alertContent: alertContent)
        alertViewController.viewModel = alertViewModel
        
        alertViewController.modalPresentationStyle = .overCurrentContext
        navigationController.present(alertViewController, animated: false, completion: {
            alertViewController.animateIn()
        })
    }
    
}
