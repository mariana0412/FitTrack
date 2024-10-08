//
//  CustomTextFieldView.swift
//  FitTrack
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

final class CustomTextFieldView: UIView {
    
    private enum Constants {
        static let identifier = "CustomTextFieldView"
    }
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet weak var textField: UITextField!
    
    var isPlaceholderVisible: Bool = true
    
    enum TextFieldState {
        case normal
        case active
        case error
    }
    
    var currentState: TextFieldState = .normal {
        didSet {
            updateUI(for: currentState)
        }
    }
    
    @IBInspectable var labelText: String? {
        get {
            label.text
        }
        set {
            label.text = newValue
        }
    }
    
    @IBInspectable var textFieldText: String? {
        get {
            textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    @IBInspectable var labelFont: UIFont? {
        get {
            label.font
        }
        set {
            label.font = newValue
        }
    }
    
    @IBInspectable var textFieldFont: UIFont? {
        get {
            textField.font
        }
        set {
            textField.font = newValue
        }
    }
    
    var isSecure: Bool?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        contentView.fixInView(self)
        
        textField.delegate = self
        currentState = .normal
        
        setupDoneButtonForTextField()
    }
    
    private func updateUI(for state: TextFieldState) {
        switch state {
        case .normal:
            label.textColor = UIColor.primaryWhite
            textFieldView.layer.borderColor = UIColor.secondaryGray.cgColor
            textField.textColor = UIColor.secondaryGray
        case .active:
            label.textColor = UIColor.primaryWhite
            textFieldView.layer.borderColor = UIColor.primaryWhite.cgColor
            textField.textColor = UIColor.primaryWhite
        case .error:
            label.textColor = .red
            textFieldView.layer.borderColor = UIColor.primaryRed.cgColor
            textField.textColor = UIColor.primaryRed
        }
    }
    
    private func setupDoneButtonForTextField() {
        textField.returnKeyType = .done
    }
    
}

extension CustomTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if isPlaceholderVisible {
            textField.text = ""
            isPlaceholderVisible = false
        }
        if isSecure == true {
            textField.isSecureTextEntry = true
        }
        currentState = .active
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
