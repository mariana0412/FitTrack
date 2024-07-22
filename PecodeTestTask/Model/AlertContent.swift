//
//  AlertContent.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 22.07.2024.
//

struct AlertContent {
    var message: String
    var okButtonTitle: String?
    var cancelButtonTitle: String?
    var okClickedAction: (() -> Void)?
    var cancelClickedAction: (() -> Void)?
}
