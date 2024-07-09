//
//  HomeViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 30.06.2024.
//

class HomeViewModel {
    private weak var coordinator: HomeCoordinator?
    private (set) var heroName: String
    
    init(coordinator: HomeCoordinator, heroName: String) {
        self.coordinator = coordinator
        self.heroName = heroName
    }

}
