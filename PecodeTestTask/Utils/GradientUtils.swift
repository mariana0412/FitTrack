//
//  GradientUtils.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class GradientUtils {
    static func addGradientLayer(to imageView: UIImageView, colors: [CGColor], locations: [Double]) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.locations = locations.map { NSNumber(value: $0) }
        gradientLayer.frame = imageView.bounds
        
        imageView.layer.addSublayer(gradientLayer)
    }
}
