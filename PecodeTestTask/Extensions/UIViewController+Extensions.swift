//
//  UIViewController+Extensions.swift
//  PecodeTestTask
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
}
