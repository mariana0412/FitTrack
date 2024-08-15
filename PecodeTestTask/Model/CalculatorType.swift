//
//  CalculatorType.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//

enum CalculatorType: String, CaseIterable {
    case bodyMassIndex = "Body Mass Index"
    case fatPercentage = "Fat Percentage"
    case dailyCalorieRequirement = "Daily Calorie Requirement"
    
    enum InputField {
        case height
        case weight
        case neck
        case waist
        case age
    }
    
    struct InputConfiguration {
        let title: String?
        let unit: String?
        let isHidden: Bool
    }
    
    var сonfigurations: [InputField: InputConfiguration] {
        switch self {
        case .bodyMassIndex:
            return [
                .height: InputConfiguration(title: "Height", unit: "cm", isHidden: false),
                .weight: InputConfiguration(title: "Weight", unit: "kg", isHidden: false),
                .neck: InputConfiguration(title: nil, unit: nil, isHidden: true),
                .waist: InputConfiguration(title: nil, unit: nil, isHidden: true),
                .age: InputConfiguration(title: nil, unit: nil, isHidden: true)
            ]
        case .fatPercentage:
            return [
                .height: InputConfiguration(title: "Height", unit: "cm", isHidden: false),
                .weight: InputConfiguration(title: nil, unit: nil, isHidden: true),
                .neck: InputConfiguration(title: "Neck", unit: "cm", isHidden: false),
                .waist: InputConfiguration(title: "Waist", unit: "cm", isHidden: false),
                .age: InputConfiguration(title: nil, unit: nil, isHidden: true)
            ]
        case .dailyCalorieRequirement:
            return [
                .height: InputConfiguration(title: "Height", unit: "cm", isHidden: false),
                .weight: InputConfiguration(title: nil, unit: nil, isHidden: true),
                .neck: InputConfiguration(title: "Neck", unit: "cm", isHidden: false),
                .waist: InputConfiguration(title: nil, unit: nil, isHidden: true),
                .age: InputConfiguration(title: "Age", unit: "years", isHidden: false)
            ]
        }
    }
}
