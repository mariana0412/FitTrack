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
            static let saveButtonName = "Save"
        }
        enum Layout {
            static let backArrowIconSize: CGFloat = 13
            static let instructionNumberOfLines = 2
        }
    }
    
    static func configureNavigationBar(for viewController: UIViewController,
                                       title: String,
                                       backAction: Selector,
                                       saveAction: Selector) -> (backButton: UIBarButtonItem, saveButton: UIBarButtonItem) {
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
        
        let backButton = UIButton(type: .system)
        let chevronLeft = UIImage(systemName: Constants.Names.backArrowIcon)?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: Constants.Layout.backArrowIconSize, weight: .medium))
        let tintedChevronLeft = chevronLeft?.withTintColor(.primaryYellow, renderingMode: .alwaysOriginal)
        backButton.setImage(tintedChevronLeft, for: .normal)
        backButton.setTitle(Constants.Names.backButtonName, for: .normal)
        backButton.titleLabel?.font = Fonts.sairaMedium18
        backButton.setTitleColor(.primaryYellow, for: .normal)
        backButton.addTarget(viewController, action: backAction, for: .touchUpInside)
        let backBarButtonItem = UIBarButtonItem(customView: backButton)
        viewController.navigationItem.leftBarButtonItem = backBarButtonItem
        
        let saveButton = UIButton(type: .custom)
        saveButton.setTitle(Constants.Names.saveButtonName, for: .normal)
        saveButton.titleLabel?.font = Fonts.sairaMedium18
        saveButton.setTitleColor(.secondaryGray, for: .disabled)
        saveButton.setTitleColor(.primaryYellow, for: .normal)
        saveButton.isEnabled = false
        saveButton.addTarget(viewController, action: saveAction, for: .touchUpInside)
        let saveBarButtonItem = UIBarButtonItem(customView: saveButton)
        viewController.navigationItem.rightBarButtonItem = saveBarButtonItem
        
        return (backBarButtonItem, saveBarButtonItem)
    }
}
