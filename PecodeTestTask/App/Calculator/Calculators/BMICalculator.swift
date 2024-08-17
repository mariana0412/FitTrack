//
//  BMICalculator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.08.2024.
//

class BMICalculator: Calculator {
    
    func calculate(inputs: [CalculatorViewModel.InputField : Double], sex: UserSex?) -> (result: Double, description: String) {
        guard let weight = inputs[.weight],
              let height = inputs[.height],
              height > 0 else {
            return (0, BMILevel.empty.rawValue)
        }
        
        let bmi = Double(weight / ((height * height) / 10000))
        let description = getBMILevel(bmi).rawValue
        
        return (bmi, description)
    }
    
    private func getBMILevel(_ bmi: Double) -> BMILevel {
        switch bmi {
        case ..<16:
            return .tooLow
        case 16..<18.5:
            return .low
        case 18.5..<25:
            return .normal
        case 25..<30:
            return .high
        case 30..<35:
            return .tooHigh
        case 35..<40:
            return .extremelyHigh
        default:
            return .tooExtremelyHigh
        }
    }
}

enum BMILevel: String {
    case tooLow = "Severe weight deficiency"
    case low = "Underweight"
    case normal = "Normal"
    case high = "Overweight"
    case tooHigh = "Obesity"
    case extremelyHigh = "Obesity is severe"
    case tooExtremelyHigh = "Very severe obesity"
    case empty = "Enter the correct values"
}
