//
//  OptionsCoordinatorDelegate.swift
//  FitTrack
//
//  Created by Mariana Piz on 25.07.2024.
//

protocol OptionsCoordinatorDelegate: AnyObject {
    func didSelectOptions(_ optionNames: [OptionDataName])
}
