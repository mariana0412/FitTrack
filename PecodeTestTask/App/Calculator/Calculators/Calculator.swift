//
//  Calculator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 17.08.2024.
//

protocol Calculator {
    func calculate(inputs: [CalculatorViewModel.InputField: Double], sex: UserSex?) -> (result: Double, description: String)
}
