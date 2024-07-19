//
//  UIStackView+Extensions.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 18.07.2024.
//

import UIKit

extension UIStackView {
    func modify(forAxis axis: NSLayoutConstraint.Axis, alignment: UIStackView.Alignment, distribution: Distribution) {
        self.axis = axis
        self.distribution = distribution
        self.alignment = alignment
    }
}
