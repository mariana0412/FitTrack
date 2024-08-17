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
    
    func validateInputs(values: [InputField: String?]) -> [InputField] {
        var invalidFields: [InputField] = []
        
        for (field, value) in values {
            if !valueIsValid(value) {
                invalidFields.append(field)
            }
        }
        
        return invalidFields
    }
    
    func calculate(values: [InputField: String?], sex: UserSex) -> (result: String, description: String) {
        let validatedValues = values.compactMapValues { value -> Double? in
            guard let value = value, !value.isEmpty, let doubleValue = Double(value), doubleValue > 0 else {
                return nil
            }
            return doubleValue
        }
        
        guard let calculator = createCalculator(for: type) else {
            return ("", "")
        }
        
        let (result, description) = calculator.calculate(inputs: validatedValues, sex: sex)
        
        return (String(format: "%.2f", result), description)
    }

    private func createCalculator(for type: CalculatorType) -> Calculator? {
        switch type {
        case .bodyMassIndex:
            return BMICalculator()
        case .fatPercentage:
            return FatPercentageCalculator()
        case .dailyCalorieRequirement:
            return BMICalculator()
        }
    }
    
    private func valueIsValid(_ value: String?) -> Bool {
        guard let value = value,
              !value.isEmpty,
              let doubleValue = Double(value),
              doubleValue > 0 else {
            return false
        }
        return true
    }

    func navigateToCalculatorSelection() {
        coordinator?.navigateToCalculatorSelection()
    }
    
    func navigateToActivityLevel(selectedActivityLevel: DailyCaloriesRateActivity?) {
        coordinator?.navigateToActivityLevel(selectedActivityLevel: selectedActivityLevel)
    }
    
}
