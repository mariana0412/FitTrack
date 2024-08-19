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

    struct ItemInfo {
        let title: String
        let icon: UIImage?
        let selectedIcon: UIImage?
    }
    
    var title: String {
        info.title
    }

    var icon: UIImage? {
        info.icon
    }

    var selectedIcon: UIImage? {
        info.selectedIcon
    }

    private var info: ItemInfo {
        switch self {
        case .home:
            return ItemInfo(
                title: "Home",
                icon: UIImage(named: "home"),
                selectedIcon: UIImage(named: "homeSelected")
            )
        case .progress:
            return ItemInfo(
                title: "Progress",
                icon: UIImage(named: "progress"),
                selectedIcon: UIImage(named: "progressSelected")
            )
        case .calculator:
            return ItemInfo(
                title: "Calculator",
                icon: UIImage(named: "calc"),
                selectedIcon: UIImage(named: "calcSelected")
            )
        case .muscles:
            return ItemInfo(
                title: "Muscles",
                icon: UIImage(named: "muscles"),
                selectedIcon: UIImage(named: "musclesSelected")
            )
        }
    }
}
