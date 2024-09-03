//
//  FatPercentageCalculator.swift
//  FitTrack
//
//  Created by Mariana Piz on 17.08.2024.
//

import Foundation

enum FatPercentLevel: String {
    case tooLow = "Severe underweight"
    case low = "Severely underweight"
    case notEnough = "Underweight"
    case normal = "Normal"
    case high = "Overweight"
    case tooHigh = "Obesity"
    case empty = "Enter the correct values"
}

class FatPercentageCalculator: Calculator {
    
    let height: Double
    let neck: Double
    let waist: Double
    let hips: Double?
    let sex: UserSex
    
    init(height: Double, neck: Double, waist: Double, hips: Double? = nil, sex: UserSex) {
        self.height = height
        self.neck = neck
        self.waist = waist
        self.hips = hips
        self.sex = sex
    }
    
    func calculate() -> (result: Double, description: String) {
        var fatPercentage: Double = 0
        if sex == .female {
            guard let hips else {
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
