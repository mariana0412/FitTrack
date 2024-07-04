//
//  CustomButton.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
class CustomButton: CustomUIComponent {
    
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
        button.layer.cornerRadius = 15.0
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
            button.backgroundColor = UIColor(named: "PrimaryYellow")
            button.layer.borderColor = UIColor(named: "PrimaryYellow")?.cgColor
            button.setTitleColor(.black, for: .normal)
            button.widthAnchor.constraint(equalToConstant: 289).isActive = true
            button.heightAnchor.constraint(equalToConstant: 49).isActive = true
            button.titleLabel?.font = UIFont(name: "Saira", size: 16)
            
        case .yellowText:
            button.setTitleColor(UIColor(named: "PrimaryYellow"), for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont(name: "Saira-SemiBold", size: 16)
            
        case .pinkText:
            button.setTitleColor(UIColor(named: "PrimaryPink"), for: .normal)
            button.backgroundColor = .clear
            button.titleLabel?.font = UIFont(name: "Saira-SemiBold", size: 16)
        }
    }
    
}
