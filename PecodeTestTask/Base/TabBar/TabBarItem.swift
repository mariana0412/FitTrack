//
//  TabBarPage.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

enum TabBarItem: String, CaseIterable {
    case home
    case progress
    case calculator
    case muscles

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .progress:
            return "Progress"
        case .calculator:
            return "Calculator"
        case .muscles:
            return "Muscles"
        }
    }

    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "home")
        case .progress:
            return UIImage(named: "progress")
        case .calculator:
            return UIImage(named: "calc")
        case .muscles:
            return UIImage(named: "muscles")
        }
    }

    var selectedIcon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "homeSelected")
        case .progress:
            return UIImage(named: "progressSelected")
        case .calculator:
            return UIImage(named: "calcSelected")
        case .muscles:
            return UIImage(named: "musclesSelected")
        }
    }
}
