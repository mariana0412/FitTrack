//
//  OptionData.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 25.07.2024.
//

struct OptionData: Codable, Equatable {
    var optionName: OptionDataName
    var valueArray: [Double?]
    var changedValue: Double?
    var dateArray: [Int]
    var isShown: Bool? = false
    
    static func == (lhs: OptionData, rhs: OptionData) -> Bool {
        lhs.optionName == rhs.optionName &&
        lhs.valueArray.elementsEqual(rhs.valueArray) { $0 == $1 } &&
        lhs.changedValue == rhs.changedValue &&
        lhs.dateArray.elementsEqual(rhs.dateArray) { $0 == $1 } &&
        lhs.isShown == rhs.isShown
    }
}
