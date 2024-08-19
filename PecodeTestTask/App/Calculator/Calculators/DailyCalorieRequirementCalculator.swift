//
//  DailyCalorieRequirementCalculator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.08.2024.
//

enum DailyCaloriesRateActivity: String, CaseIterable  {
    case sitting = "sedentary lifestyle"
    case light = "light activity (1 to 3 times a week)"
    case middle = "medium activity (training 3-5 times a week)"
    case high = "high activity (training 6-7 times a week)"
    case extremal = "extremely high activity"
    
    var activityLevel: DailyCaloriesRateActivityLevel {
        switch self {
        case .sitting:
            return .sitting
        case .light:
            return .light
        case .middle:
            return .middle
        case .high:
            return .high
        case .extremal:
            return .extremal
        }
    }
    
    enum DailyCaloriesRateActivityLevel: Double {
        case sitting = 1.2
        case light = 1.38
        case middle = 1.56
        case high = 1.73
        case extremal = 1.95
    }
}

class DailyCalorieRequirementCalculator: Calculator {
    
    let height: Double
    let weight: Double
    let age: Double
    let sex: UserSex
    let activity: DailyCaloriesRateActivity
    
    init(height: Double, weight: Double, age: Double, sex: UserSex, activity: DailyCaloriesRateActivity) {
        self.height = height
        self.weight = weight
        self.age = age
        self.sex = sex
        self.activity = activity
    }
    
    func calculate() -> (result: Double, description: String) {
        let sexConstant = (sex == .male) ? 5 : -161
        let dailyCalories = (10 * weight + 6.25 * height - 5 * Double(age) + Double(sexConstant)) * activity.activityLevel.rawValue
        
        return (dailyCalories, "Calories/day")
    }
}
