//
//  UIViewController+Extensions.swift
//  FitTrack
//
//  Created by Mariana Piz on 17.08.2024.
//

import UIKit

extension UIViewController {
    static func instantiate<T: UIViewController>(fromStoryboard storyboardName: String,
                                                 viewControllerIdentifier: String) -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: viewControllerIdentifier) as! T
    }
    
    func setupDismissKeyboardOnTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
