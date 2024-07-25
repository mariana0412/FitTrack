//
//  OptionDataname.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

enum OptionDataName: String, Codable, CaseIterable {
    case height = "Height"
    case weight = "Weight"
    case neck = "Neck"
    case shoulders = "Shoulders"
    case leftBiceps = "Left biceps"
    case rightBiceps = "Right biceps"
    case leftThigh = "Left thigh"
    case rightThigh = "Right thigh"
    case rightForearm = "Right forearm"
    case leftForearm = "Left forearm"
    case chest = "Chest"
    case leftLowerLeg = "Left lower leg"
    case rightLowerLeg = "Right lower leg"
    case leftAnkle = "Left ankle"
    case rightAnkle = "Right ankle"
    
    var metricValue: String {
        switch self {
        case .weight:
            return "kg"
        default:
            return "cm"
        }
    }
}
