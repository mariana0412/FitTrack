//
//  AlertContent.swift
//  FitTrack
//
//  Created by Mariana Piz on 22.07.2024.
//

import UIKit

enum AlertType {
    case twoButtons
    case oneButton
    case noButtons
}

struct AlertContent {
    let alertType: AlertType
    var message: String
    var okButtonTitle: String?
    var cancelButtonTitle: String?
    var okClickedAction: (() -> Void)?
    var cancelClickedAction: (() -> Void)?
    var icon: UIImage?
}
