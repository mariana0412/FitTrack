//
//  NavigationBarConfigurator.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 22.07.2024.
//

import UIKit

class NavigationBarConfigurator {
    private enum Constants {
        enum Names {
            static let backArrowIcon = "chevron.left"
            static let backButtonName = "  Back"
        }
        enum Layout {
            static let backArrowIconSize: CGFloat = 13
            static let instructionNumberOfLines = 2
        }
    }
    
    static func configureNavigationBar(for viewController: UIViewController,
                                       title: String,
                                       rightButtonName: String? = nil,
                                       backAction: Selector? = nil,
                                       rightButtonAction: Selector? = nil) -> (backButton: UIBarButtonItem?, rightButton: UIBarButtonItem?) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let navigationBar = viewController.navigationController?.navigationBar
        navigationBar?.standardAppearance = appearance
        navigationBar?.scrollEdgeAppearance = appearance
        navigationBar?.compactAppearance = appearance
        navigationBar?.prefersLargeTitles = false
        navigationBar?.isTranslucent = true
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = Fonts.sairaMedium18
        titleLabel.textColor = .primaryWhite
        viewController.navigationItem.titleView = titleLabel
        
        var backBarButtonItem: UIBarButtonItem?
        if let backAction = backAction {
            let backButton = UIButton(type: .system)
            let chevronLeft = UIImage(systemName: Constants.Names.backArrowIcon)?
                .withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.Layout.backArrowIconSize, weight: .medium))
            let tintedChevronLeft = chevronLeft?.withTintColor(.primaryYellow, renderingMode: .alwaysOriginal)
            backButton.setImage(tintedChevronLeft, for: .normal)
            backButton.setTitle(Constants.Names.backButtonName, for: .normal)
            backButton.titleLabel?.font = Fonts.sairaMedium18
            backButton.setTitleColor(.primaryYellow, for: .normal)
            backButton.addTarget(viewController, action: backAction, for: .touchUpInside)
            backBarButtonItem = UIBarButtonItem(customView: backButton)
            viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        }
        
        var rightBarButtonItem: UIBarButtonItem?
        if let rightButtonName = rightButtonName,
           let rightAction = rightButtonAction {
            let rightButton = UIButton(type: .custom)
            rightButton.setTitle(rightButtonName, for: .normal)
            rightButton.titleLabel?.font = Fonts.sairaMedium18
            rightButton.setTitleColor(.secondaryGray, for: .disabled)
            rightButton.setTitleColor(.primaryYellow, for: .normal)
            rightButton.isEnabled = false
            rightButton.addTarget(viewController, action: rightAction, for: .touchUpInside)
            rightBarButtonItem = UIBarButtonItem(customView: rightButton)
            viewController.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
        
        return (backBarButtonItem, rightBarButtonItem)
    }
}
