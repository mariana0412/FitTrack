//
//  UIImageView+Extension.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 21.07.2024.
//

import UIKit

extension UIImageView {
    func setImageWithBorder(image: UIImage?, borderColor: UIColor = .primaryYellow, borderWidth: CGFloat = 1, cornerRadius: CGFloat = 8) {
        self.image = image
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor.cgColor
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
}
