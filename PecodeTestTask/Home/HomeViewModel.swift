//
//  HomeViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

class HomeViewModel {
    weak var coordinator: HomeCoordinator?

    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }

}
