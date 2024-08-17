//
//  FatPercentageCalculator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.08.2024.
//

import Foundation

class FatPercentageCalculator: Calculator {
    
    func calculate(inputs: [CalculatorViewModel.InputField: Double], sex: UserSex?) -> (result: Double, description: String) {
        guard let height = inputs[.height],
              let neck = inputs[.neck],
              let waist = inputs[.waist],
              let sex = sex else {
            return (0, FatPercentLevel.empty.rawValue)
        }
        
        var fatPercentage: Double = 0
        if sex == .female {
            guard let hips = inputs[.hips] else {
                return (0, FatPercentLevel.empty.rawValue)
            }
            fatPercentage = (495 / (1.2958 - 0.35 * log10(waist + hips - neck) + 0.221 * log10(height))) - 450
        } else {
            fatPercentage = (495 / (1.0324 - 0.19077 * log10(waist - neck) + 0.15456 * log10(height))) - 450
        }
        if fatPercentage < 0 {
            fatPercentage = 0
        }
        
        let description = getFatPercentageDescription(fatPercentage)
        return (fatPercentage, description.rawValue)
    }
    
    private func getFatPercentageDescription(_ fatPercentage: Double) -> FatPercentLevel {
        switch fatPercentage {
        case ..<5:
            return .tooLow
        case 5..<13:
            return .low
        case 13..<17:
            return .notEnough
        case 17..<22:
            return .normal
        case 22..<29:
            return .high
        default:
            return .tooHigh
        }
    }
}

enum FatPercentLevel: String {
    case tooLow = "Severe underweight"
    case low = "Severely underweight"
    case notEnough = "Underweight"
    case normal = "Normal"
    case high = "Overweight"
    case tooHigh = "Obesity"
    case empty = "Enter the correct values"
}
