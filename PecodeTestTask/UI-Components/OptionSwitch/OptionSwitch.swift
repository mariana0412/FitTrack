//
//  OptionSwitch.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 25.07.2024.
//

import UIKit

protocol OptionSwitchDelegate: AnyObject {
    func optionSwitchDidChange(_ optionSwitch: OptionSwitch)
    func optionValueDidChange(_ optionSwitch: OptionSwitch, newValue: String)
}

class OptionSwitch: UIView {
    
    private enum Constants {
        static let identifier = "OptionSwitch"
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var option: CustomTextFieldView!
    @IBOutlet private weak var metricValue: UILabel!
    @IBOutlet weak var optionSwitch: CustomSwitch!
    
    weak var delegate: OptionSwitchDelegate?
    var optionName: String = ""
    var optionValue: String? {
        option.textFieldText
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
        Bundle.main.loadNibNamed(Constants.identifier, owner: self, options: nil)
        contentView.fixInView(self)
        
        option.textField.delegate = self
        optionSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        option.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }
    
    func configure(optionName: String, value: String?, metric: String, isSwitchOn: Bool) {
        option.labelText = optionName
        option.textFieldText = value
        self.optionName = optionName
        
        metricValue.text = metric
        metricValue.font = Fonts.helveticaNeueMedium18
        metricValue.textColor = .secondaryGray
        
        optionSwitch.setOn(isSwitchOn, animated: false)
    }
    
    func setErrorState() {
        option.currentState = .error
    }

    func setNormalState() {
        option.currentState = .normal
    }
    
    @objc private func switchChanged() {
        delegate?.optionSwitchDidChange(self)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if let newValue = textField.text {
            delegate?.optionValueDidChange(self, newValue: newValue)
        }
    }
}

extension OptionSwitch: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let newValue = textField.text {
            delegate?.optionValueDidChange(self, newValue: newValue)
        }
    }
}
