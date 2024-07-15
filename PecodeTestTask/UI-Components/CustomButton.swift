//
//  CustomButton.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
final class CustomButton: UIButton {
    
    enum Style: Int {
        case yellowBorder
        case yellowText
        case pinkText
    }
    
    private enum Constants {
        enum Layout {
            static let fontSize: CGFloat = 16.0
            static let fontName = "Saira-Regular"
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
    
    @IBInspectable var buttonStyle: Int = 0 {
        didSet {
            let style = Style(rawValue: buttonStyle) ?? .yellowBorder
            applyStyle(style)
        }
    }
    
    @IBInspectable var buttonTitle: String? {
        didSet {
            setTitle(buttonTitle, for: .normal)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    private func commonInit() {
        self.backgroundColor = .clear
        self.clipsToBounds = true
        applyStyle(Style(rawValue: buttonStyle) ?? .yellowBorder)
    }
    
    private func applyStyle(_ style: Style) {
        switch style {
        case .yellowBorder:
            self.backgroundColor = Constants.Colors.yellowBorderColor
            self.setTitleColor(Constants.Colors.yellowBorderTitleColor, for: .normal)
            self.titleLabel?.font = UIFont(name: Constants.Layout.fontName, size: Constants.Layout.fontSize)
            
        case .yellowText:
            self.backgroundColor = .clear
            self.setTitleColor(Constants.Colors.yellowTextColor, for: .normal)
            self.titleLabel?.font = UIFont(name: Constants.Layout.boldFontName, size: Constants.Layout.fontSize)
            
        case .pinkText:
            self.backgroundColor = .clear
            self.setTitleColor(Constants.Colors.pinkTextColor, for: .normal)
            self.titleLabel?.font = UIFont(name: Constants.Layout.boldFontName, size: Constants.Layout.fontSize)
        }
    }
    
    func setupButtonFont(font: UIFont?, color: UIColor?) {
        let states: [UIControl.State] = [.normal, .disabled, .highlighted, .selected, .focused]
        
        for state in states {
            if let title = self.title(for: state) {
                self.setAttributedTitle(attributedTitle(for: title, font: font, color: color), for: state)
            }
        }
    }
    
    private func attributedTitle(for title: String, font: UIFont?, color: UIColor?) -> NSAttributedString {
        return NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: font as Any,
            NSAttributedString.Key.foregroundColor: color as Any
        ])
    }
}
