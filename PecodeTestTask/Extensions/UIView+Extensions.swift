//
//  UIView+Extensions.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 05.07.2024.
//

import UIKit

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

extension UIView {
    func showCustomAlert(message: String,
                         okButtonTitle: String = "Ok",
                         cancelButtonTitle: String? = nil,
                         okClickedAction: (() -> Void)? = nil,
                         cancelClickedAction: (() -> Void)? = nil) {
        let customAlertView = CustomAlert()
        customAlertView.presentAlert(in: self, 
                                     message: message,
                                     okButtonTitle: okButtonTitle,
                                     cancelButtonTitle: cancelButtonTitle,
                                     okClickedAction: okClickedAction,
                                     cancelClickedAction: cancelClickedAction)
    }
}
