//
//  CustomTextFieldView.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

final class CustomTextFieldView: UIView {
    let kCONTENT_XIB_NAME = "CustomTextFieldView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
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
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    @IBInspectable var textFieldText: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        textField.delegate = self
        currentState = .normal
        
        setupDoneButtonForTextField()
    }
    
    func updateUI(for state: TextFieldState) {
        switch state {
        case .normal:
            label.textColor = UIColor.primaryWhite
            textField.layer.borderColor = UIColor.secondaryGray.cgColor
            textField.textColor = UIColor.secondaryGray
        case .active:
            label.textColor = UIColor.primaryWhite
            textField.layer.borderColor = UIColor.primaryWhite.cgColor
            textField.textColor = UIColor.primaryWhite
        case .error:
            label.textColor = .red
            textField.layer.borderColor = UIColor.primaryRed.cgColor
            textField.textColor = UIColor.primaryRed
        }
    }
    
    func setupDoneButtonForTextField() {
        textField.returnKeyType = .done
    }
    
}

extension CustomTextFieldView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        currentState = .active
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        currentState = .normal
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange, with: string)
            if updatedText.count > 10 {
                currentState = .error
            } else {
                currentState = .active
            }
        }
        return true
    }
}
