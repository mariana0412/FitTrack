//
//  CustomTextFieldView.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

class CustomTextFieldView: UIView {
    let kCONTENT_XIB_NAME = "CustomTextFieldView"
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
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
        
        nameTextField.delegate = self
        currentState = .normal
    }
    
    func updateUI(for state: TextFieldState) {
        switch state {
        case .normal:
            label.textColor = UIColor.primaryWhite
            nameTextField.layer.borderColor = UIColor.secondaryGray.cgColor
            nameTextField.textColor = UIColor.secondaryGray
        case .active:
            label.textColor = UIColor.primaryWhite
            nameTextField.layer.borderColor = UIColor.primaryWhite.cgColor
            nameTextField.textColor = UIColor.primaryWhite
        case .error:
            label.textColor = .red
            nameTextField.layer.borderColor = UIColor.primaryRed.cgColor
            nameTextField.textColor = UIColor.primaryRed
        }
    }
    
}

extension UIView {
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
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
