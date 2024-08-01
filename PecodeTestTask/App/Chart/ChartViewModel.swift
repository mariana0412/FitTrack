//
//  ChartViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 01.08.2024.
//

class ChartViewModel {
    
    let subtitleText = "Displaying dynamics relative to data from"
    
    let optionData: OptionData
    private var coordinator: ChartCoordinator?
    
    var titleText: String {
        "\(optionData.optionName.rawValue), \(optionData.optionName.metricValue)"
    }
    
    var navigationItemTitle: String {
        "\(optionData.optionName.rawValue) Chart"
    }
    
    var initialDate: String {
        DateUtils.convertTimestampToString(optionData.dateArray.first)
    }
    
    init(coordinator: ChartCoordinator?, optionData: OptionData) {
        self.coordinator = coordinator
        self.optionData = optionData
    }
    
    func navigateToProgress() {
        coordinator?.navigateToProgress()
    }
    
}
