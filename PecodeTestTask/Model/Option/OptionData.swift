//
//  OptionData.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 25.07.2024.
//

struct OptionData: Codable, Equatable {
    var optionName: OptionDataName
    var value: Double?
    var isShown: Bool? = false
    
    static func == (lhs: OptionData, rhs: OptionData) -> Bool {
        return lhs.optionName == rhs.optionName &&
               lhs.value == rhs.value &&
               lhs.isShown == rhs.isShown
    }
}
