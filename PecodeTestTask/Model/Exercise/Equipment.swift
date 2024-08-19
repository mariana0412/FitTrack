//
//  Equipment.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 06.08.2024.
//

enum Equipment: String, Decodable {
    case dumbbell = "Dumbbell"
    case barbell = "Barbell"
    case cableMachine = "Cable Machine"
    case bodyweight = "Body Weight"

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        
        switch rawValue {
        case "dumbbells":
            self = .dumbbell
        case "barbell":
            self = .barbell
        case "cable machine", "machine":
            self = .cableMachine
        case "bodyweight", "body weight", "own body weight":
            self = .bodyweight
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid value for Equipment: \(rawValue)")
        }
    }
}
