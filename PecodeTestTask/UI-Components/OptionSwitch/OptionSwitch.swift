//
//  OptionSwitch.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 25.07.2024.
//

import UIKit

class OptionSwitch: UIView {
    
    private enum Constants {
        static let identifier = "OptionSwitch"
    }
    
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var option: CustomTextFieldView!
    @IBOutlet private weak var metricValue: UILabel!
    @IBOutlet private weak var optionSwitch: CustomSwitch!
    
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
    }
    
    func configure(optionName: String, value: String?, metric: String, isSwitchOn: Bool) {
        option.labelText = optionName
        option.textFieldText = value
        
        metricValue.text = metric
        metricValue.font = Fonts.helveticaNeueMedium18
        metricValue.textColor = .secondaryGray
        
        optionSwitch.setOn(isSwitchOn, animated: false)
    }
    
}
