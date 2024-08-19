//
//  MeasurementInputView.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 15.08.2024.
//

import UIKit

final class MeasurementInputView: UIView {
    
    enum TextFieldState {
        case normal
        case active
        case error
    }
        
    private enum Constants {
        static let identifier = "MeasurementInputView"
        
        enum Layout {
            enum TextFieldView {
                static let corderRadius: CGFloat = 12
                static let borderWidth: CGFloat = 1
            }
        }
    }
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textFieldView: UIView!
    @IBOutlet private(set) weak var textField: UITextField!
    @IBOutlet private weak var unitLabel: UILabel!
    
    var currentState: TextFieldState = .normal {
        didSet {
            updateUI(for: currentState)
        }
    }

    @IBInspectable var titleLabelText: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    @IBInspectable var textFieldText: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    @IBInspectable var unitLabelText: String? {
        get { unitLabel.text }
        set { unitLabel.text = newValue }
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
        let nib = UINib(nibName: Constants.identifier, bundle: nil)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else { return }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        
        currentState = .normal
    }
    
    func configure(title: String, unit: String){
        titleLabel.text = title
        unitLabel.text = unit
    }
    
    private func updateUI(for state: TextFieldState) {
        titleLabel.textColor = .primaryWhite
        titleLabel.font = Fonts.helveticaNeue18
        
        textFieldView.layer.cornerRadius = Constants.Layout.TextFieldView.corderRadius
        textFieldView.layer.borderWidth = Constants.Layout.TextFieldView.borderWidth
        
        unitLabel.textColor = .secondaryGray
        unitLabel.font = Fonts.helveticaNeueMedium18
        
        switch state {
        case .normal:
            textFieldView.layer.borderColor = UIColor.secondaryGray.cgColor
            textField.textColor = .secondaryGray
        case .active:
            textFieldView.layer.borderColor = UIColor.primaryWhite.cgColor
            textField.textColor = .primaryWhite
        case .error:
            textFieldView.layer.borderColor = UIColor.primaryRed.cgColor
            textField.textColor = .primaryRed
        }
    }
    
}

