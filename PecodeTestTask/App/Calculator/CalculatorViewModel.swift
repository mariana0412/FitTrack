//
//  CalculatorViewModel.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//

class CalculatorViewModel {
    
    let navigationBarTitle = "Calculator"
    let chooseActivityLevelButtonTitle = "Choose Activity Level"
    let calculateButtonTitle = "Calculate"
    let segmentedControlTitles = "Superman,Superwoman"
    let resultErrorMessage = "Enter the correct values"

    private var coordinator: CalculatorCoordinator?
    let type: CalculatorType
    
    init(coordinator: CalculatorCoordinator?, type: CalculatorType) {
        self.coordinator = coordinator
        self.type = type
    }
    
    enum InputField {
        case height
        case weight
        case neck
        case waist
        case hips
        case age
    }
    
    struct InputConfiguration {
        let title: String?
        let unit: String?
        let isHidden: Bool
    }
    
    private let fieldTitlesAndUnits: [InputField: (title: String, unit: String)] = [
        .height: (title: "Height", unit: "cm"),
        .weight: (title: "Weight", unit: "kg"),
        .neck: (title: "Neck", unit: "cm"),
        .waist: (title: "Waist", unit: "cm"),
        .hips: (title: "Hips", unit: "cm"),
        .age: (title: "Age", unit: "years")
    ]
    
    func configurations(sex: UserSex) -> [InputField: InputConfiguration] {
        switch type {
        case .bodyMassIndex:
            return generateConfiguration(
                fields: [.height, .weight],
                hiddenFields: [.neck, .waist, .hips, .age]
            )
            
        case .fatPercentage:
            return generateConfiguration(
                fields: [.height, .neck, .waist],
                hiddenFields: [.weight, .age],
                conditionalFields: [.hips: (sex != .female)]
            )
            
        case .dailyCalorieRequirement:
            return generateConfiguration(
                fields: [.height, .weight, .age],
                hiddenFields: [.neck, .waist, .hips]
            )
        }
    }
        
    private func generateConfiguration(
        fields: [InputField],
        hiddenFields: [InputField],
        conditionalFields: [InputField: Bool] = [:]
    ) -> [InputField: InputConfiguration] {
        
        var config: [InputField: InputConfiguration] = [:]
        
        for field in fields {
            if let titleAndUnit = fieldTitlesAndUnits[field] {
                config[field] = InputConfiguration(title: titleAndUnit.title, unit: titleAndUnit.unit, isHidden: false)
            }
        }
        
        for field in hiddenFields {
            config[field] = InputConfiguration(title: nil, unit: nil, isHidden: true)
        }
        
        for (field, isHidden) in conditionalFields {
            if let titleAndUnit = fieldTitlesAndUnits[field] {
                config[field] = InputConfiguration(title: titleAndUnit.title, unit: titleAndUnit.unit, isHidden: isHidden)
            }
        }
        
        return config
    }
    
    func validateInputs(values: [InputField: String?]) -> (invalidFields: [InputField], 
                                                           validatedValues: [InputField: Double]) {
        var invalidFields: [InputField] = []
        var validatedValues: [InputField: Double] = [:]
        
        for (field, value) in values {
            let validation = valueIsValid(value)
            if validation.isValid, let doubleValue = validation.value {
                validatedValues[field] = doubleValue
            } else {
                invalidFields.append(field)
            }
        }
        
        return (invalidFields, validatedValues)
    }
    
    func calculate(values: [InputField: Double],
                   sex: UserSex,
                   activityLevel: DailyCaloriesRateActivity?
    ) -> (result: String, description: String) {
        
        guard let calculator = createCalculator(for: type,
                                                inputs: values,
                                                sex: sex,
                                                activity: activityLevel) else { return ("", "") }
        
        let (result, description) = calculator.calculate()
        
        return (String(format: "%.2f", result), description)
    }

    private func createCalculator(for type: CalculatorType, 
                                  inputs: [InputField: Double],
                                  sex: UserSex,
                                  activity: DailyCaloriesRateActivity?) -> Calculator? {
        switch type {
        case .bodyMassIndex:
            if let height = inputs[.height],
               let weight = inputs[.weight] {
                return BMICalculator(height: height,
                                     weight: weight)
            }
        case .fatPercentage:
            if let height = inputs[.height],
               let neck = inputs[.neck],
               let waist = inputs[.waist] {
                
                let hips = sex == .female ? inputs[.hips] : nil
                    
                if sex == .female && hips == nil {
                    return nil
                }
                return FatPercentageCalculator(height: height,
                                               neck: neck,
                                               waist: waist,
                                               hips: hips,
                                               sex: sex)
            }
        case .dailyCalorieRequirement:
            if let height = inputs[.height],
               let weight = inputs[.weight],
               let age = inputs[.age],
               let activity
            {
                return DailyCalorieRequirementCalculator(height: height,
                                                         weight: weight,
                                                         age: age,
                                                         sex: sex, 
                                                         activity: activity)
            }
        }
        return nil
    }
    
    private func valueIsValid(_ value: String?) -> (isValid: Bool, value: Double?) {
        guard let value = value,
              !value.isEmpty,
              let doubleValue = Double(value),
              doubleValue > 0 else {
            return (false, nil)
        }
        return (true, doubleValue)
    }

    func navigateToCalculatorSelection() {
        coordinator?.navigateToCalculatorSelection()
    }
    
    func navigateToActivityLevel(selectedActivityLevel: DailyCaloriesRateActivity?) {
        coordinator?.navigateToActivityLevel(selectedActivityLevel: selectedActivityLevel)
    }
    
}
