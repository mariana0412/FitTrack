//
//  DeleteAccountViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 03.08.2024.
//

class DeleteAccountViewModel {
    
    let navigationItemTitle = "Delete account"
    
    private var coordinator: DeleteAccountCoordinator?
    
    init(coordinator: DeleteAccountCoordinator?) {
        self.coordinator = coordinator
    }
    
    func navigateToProfile() {
        coordinator?.navigateToProfile()
    }
    
}
