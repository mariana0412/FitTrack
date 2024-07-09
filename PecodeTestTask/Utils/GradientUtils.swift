//
//  GradientUtils.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class GradientUtils {
    static func addGradientLayer(to imageView: UIImageView, colors: [CGColor], locations: [NSNumber]?) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        if let locations = locations {
            gradientLayer.locations = locations
        }
        gradientLayer.frame = imageView.bounds
        
        imageView.layer.addSublayer(gradientLayer)
    }
}
