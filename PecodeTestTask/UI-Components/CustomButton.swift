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
            button.backgroundColor = UIColor.primaryYellow
            button.layer.borderColor = UIColor.primaryYellow.cgColor
            button.setTitleColor(UIColor.black, for: .normal)
            button.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonWidth).isActive = true
            button.heightAnchor.constraint(equalToConstant: Constants.Layout.buttonHeight).isActive = true
            button.titleLabel?.font = UIFont(name: Constants.Layout.fontName, size: Constants.Layout.fontSize)
            
        case .yellowText:
            button.setTitleColor(UIColor.primaryYellow, for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont(name: Constants.Layout.boldFontName, size: Constants.Layout.fontSize)
            
        case .pinkText:
            button.setTitleColor(UIColor.primaryPink, for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont(name: Constants.Layout.boldFontName, size: Constants.Layout.fontSize)
        }
    }
    
}
