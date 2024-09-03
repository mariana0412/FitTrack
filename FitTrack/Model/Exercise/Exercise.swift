//
//  Exercise.swift
//  FitTrack
//
//  Created by Mariana Piz on 06.08.2024.
//

struct Exercise: Decodable {
    let name: String
    let imageIcon: String
    let exerciseImage: String
    let descriptions: String
    let exerciseType: ExerciseType
    let equipment: Equipment
    let level: Level
    
    var attributes: String {
        return "\(equipment.rawValue.capitalized), \(level.rawValue.capitalized), \(exerciseType.rawValue.capitalized)"
    }
}
