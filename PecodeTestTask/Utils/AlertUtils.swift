//
//  AlertUtils.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 11.07.2024.
//

import UIKit

class AlertUtils {
    static func createAlert(title: String = "Alert", message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }
}

