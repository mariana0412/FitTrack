//
//  CustomAlert.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 18.07.2024.
//

import UIKit

final class CustomAlert: UIView {
    let kCONTENT_XIB_NAME = "CustomAlert"
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var message: UILabel!
    @IBOutlet private weak var okButton: CustomButton!
    @IBOutlet private weak var cancelButton: CustomButton!
    
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
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        contentView.fixInView(self)
        
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        alertView.backgroundColor = .black
        alertView.layer.borderWidth = 1
        alertView.layer.cornerRadius = 8
        alertView.layer.borderColor = UIColor.primaryWhite.cgColor
        
        okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
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
        }

        animateAlert()
    }
    
    private func animateAlert() {
        alertView.transform = CGAffineTransform(translationX: 0, y: frame.height)
        
        UIView.animate(withDuration: 0.7,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: .curveEaseInOut,
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
        UIView.animate(withDuration: 0.3, animations: {
            self.alertView.transform = CGAffineTransform(translationX: 0, y: self.frame.height)
        }) { _ in
            self.removeFromSuperview()
        }
    }
    
}
