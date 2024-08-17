//
//  ActivityLevelViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.08.2024.
//

class ActivityLevelViewModel {
    
    let chooseYourActivityLevelText = "Choose Your Activity Level"
    let confirmButtonText = "Confirm"
    
    private var coordinator: ActivityLevelCoordinator?
    
    let activityLevels = DailyCaloriesRateActivity.allCases
    var selectedActivityLevel: DailyCaloriesRateActivity?
    
    init(coordinator: ActivityLevelCoordinator?, selectedActivityLevel: DailyCaloriesRateActivity?) {
        self.coordinator = coordinator
        self.selectedActivityLevel = selectedActivityLevel
    }
    
    func handleActivityLevelSelection(for activityLevel: DailyCaloriesRateActivity) {
        selectedActivityLevel = activityLevel
    }
    
    func isActivityLevelSelected(_ activityLevel: DailyCaloriesRateActivity) -> Bool {
        selectedActivityLevel == activityLevel
    }
    
    func navigateToCalculator() {
        coordinator?.navigateToCalculator(with: selectedActivityLevel)
    }
    
}
