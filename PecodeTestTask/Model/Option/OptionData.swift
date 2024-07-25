//
//  OptionData.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 25.07.2024.
//

struct OptionData: Codable {
    var optionName: OptionDataName
    var value: Double?
    var isShown: Bool? = false
}
