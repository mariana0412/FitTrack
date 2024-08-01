//
//  ChartViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

class ChartViewModel {
    
    let navigationItemTitle: String
    
    private var coordinator: ChartCoordinator?
    let optionData: OptionData
    
    init(coordinator: ChartCoordinator?, optionData: OptionData) {
        self.coordinator = coordinator
        self.optionData = optionData
        self.navigationItemTitle = "\(optionData.optionName.rawValue) Chart"
    }
    
    func navigateToProgress() {
        coordinator?.navigateToProgress()
    }
    
}
