//
//  UIImage+Extensions.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 22.07.2024.
//

import UIKit

extension UIImage {
    static func ==(lhs: UIImage, rhs: UIImage) -> Bool {
        lhs === rhs || lhs.pngData() == rhs.pngData()
    }
    
    static func !=(lhs: UIImage, rhs: UIImage) -> Bool {
        !(lhs == rhs)
    }
}
