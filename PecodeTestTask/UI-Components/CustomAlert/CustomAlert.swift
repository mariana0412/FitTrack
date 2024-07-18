//
//  CustomAlert.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 18.07.2024.
//

import UIKit

final class CustomAlert: UIView {
    
    private enum Constants {
        static let identifier = "CustomAlert"
        
        enum Layout {
            static let contentViewBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            
            static let alertViewBackgroundColor = UIColor.black
            static let alertViewBorderWidth: CGFloat = 1.0
            static let alertViewCornerRadius: CGFloat = 8.0
            static let alertViewBorderColor = UIColor.primaryWhite.cgColor
            
            static let messageNumberOfLines = 0
            
            static let buttonWidth: CGFloat = 129
        }
        
        enum Animation {
            static let presentDuration: TimeInterval = 0.7
            static let presentDelay: TimeInterval = 0
            static let presentSpringDamping: CGFloat = 0.8
            static let presentInitialSpringVelocity: CGFloat = 0.1
            static let presentOptions: UIView.AnimationOptions = .curveEaseInOut
            
            static let dismissDuration: TimeInterval = 0.3
        }
    }
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var okButton: CustomButton!
    @IBOutlet private weak var cancelButton: CustomButton!
    @IBOutlet weak var buttonsContainer: UIStackView!
    
    private var okClickedAction: (() -> Void)?
    private var cancelClickedAction: (() -> Void)?
    
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
        
        setupUI()
        setupActions()
    }
    
    func presentAlert(in view: UIView,
                      message: String,
                      okButtonTitle: String = "Ok",
                      cancelButtonTitle: String? = nil,
                      okClickedAction: (() -> Void)? = nil,
                      cancelClickedAction: (() -> Void)? = nil) {
        frame = view.bounds
        view.addSubview(self)
        
        self.message.text = message
        self.okButton.setTitle(okButtonTitle, for: .normal)
        self.okClickedAction = okClickedAction
        
        if let cancelButtonTitle {
            self.cancelButton.setTitle(cancelButtonTitle, for: .normal)
            self.cancelClickedAction = cancelClickedAction
        } else {
            self.cancelButton.isHidden = true
            self.buttonsContainer.modify(forAxis: .vertical,
                                         alignment: .center,
                                         distribution: .fillProportionally)
        }

        animateAlert()
    }
    
    private func setupUI() {
        contentView.fixInView(self)
        contentView.backgroundColor = Constants.Layout.contentViewBackgroundColor
        
        alertView.backgroundColor = Constants.Layout.alertViewBackgroundColor
        alertView.layer.borderWidth = Constants.Layout.alertViewBorderWidth
        alertView.layer.cornerRadius = Constants.Layout.alertViewCornerRadius
        alertView.layer.borderColor = Constants.Layout.alertViewBorderColor
        
        message.font = Fonts.helveticaNeue16
        message.textColor = .primaryWhite
        message.numberOfLines = Constants.Layout.messageNumberOfLines
        
        okButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
        okButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonWidth).isActive = true
        cancelButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
    }
    
    private func setupActions() {
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    private func animateAlert() {
        alertView.transform = CGAffineTransform(translationX: 0, y: frame.height)
        
        UIView.animate(withDuration: Constants.Animation.presentDuration,
                       delay: Constants.Animation.presentDelay,
                       usingSpringWithDamping: Constants.Animation.presentSpringDamping,
                       initialSpringVelocity: Constants.Animation.presentInitialSpringVelocity,
                       options: Constants.Animation.presentOptions,
                       animations: {
                            self.alertView.transform = .identity
                        }, completion: nil)
    }
    
    @objc private func okButtonTapped() {
        okClickedAction?()
        dismissAlert()
    }
    
    @objc private func cancelButtonTapped() {
        cancelClickedAction?()
        dismissAlert()
    }
    
    @objc private func dismissAlert() {
        UIView.animate(withDuration: Constants.Animation.dismissDuration, animations: {
            self.alertView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
}
