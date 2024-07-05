//
//  CustomButton.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
final class CustomButton: CustomUIComponent {
    
    enum Style: Int {
        case yellowBorder
        case yellowText
        case pinkText
    }
    
    @IBInspectable var buttonStyle: Int = 0 {
        didSet {
            let style = Style(rawValue: buttonStyle) ?? .yellowBorder
            applyStyle(style)
        }
    }
    
    @IBInspectable var buttonTitle: String? {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }
    
    private var button: UIButton!
    
    private enum Constants {
        enum Layout {
            static let buttonCornerRadius: CGFloat = 15.0
            static let buttonWidth: CGFloat = 289.0
            static let buttonHeight: CGFloat = 49.0
            static let fontSize: CGFloat = 16.0
            static let fontName = "Saira"
            static let boldFontName = "Saira-SemiBold"
            static let borderWidth: CGFloat = 1.0
        }
        
        enum Colors {
            static let yellowBorderColor = UIColor.primaryYellow
            static let yellowBorderTitleColor = UIColor.black
            static let yellowTextColor = UIColor.primaryYellow
            static let pinkTextColor = UIColor.primaryPink
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
        setupButton()
    }
    
    private func setupButton() {
        self.backgroundColor = .clear
        button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Constants.Layout.buttonCornerRadius
        button.clipsToBounds = true
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.topAnchor.constraint(equalTo: topAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func applyStyle(_ style: Style) {
        switch style {
        case .yellowBorder:
            button.backgroundColor = Constants.Colors.yellowBorderColor
            button.setTitleColor(Constants.Colors.yellowBorderTitleColor, for: .normal)
            button.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight).isActive = true
            button.titleLabel?.font = UIFont(name: Constants.Layout.fontName, size: Constants.Layout.fontSize)
            
        case .yellowText:
            button.setTitleColor(Constants.Colors.yellowTextColor, for: .normal)
            button.titleLabel?.font = UIFont(name: Constants.Layout.boldFontName, size: Constants.Layout.fontSize)
            
        case .pinkText:
            button.setTitleColor(Constants.Colors.pinkTextColor, for: .normal)
            button.titleLabel?.font = UIFont(name: Constants.Layout.boldFontName, size: Constants.Layout.fontSize)
        }
    }
    
}
