//
//  AlertViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 22.07.2024.
//

class AlertViewModel {
    
    var alertContent: AlertContent
    private var coordinator: AlertCoordinator?
    
    init(coordinator: AlertCoordinator?, alertContent: AlertContent) {
        self.coordinator = coordinator
        self.alertContent = alertContent
    }
}
