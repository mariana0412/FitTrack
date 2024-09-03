//
//  GradientUtils.swift
//  FitTrack
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
    
    static func addRadialGradientLayer(to imageView: UIImageView, colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.type = .radial
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = imageView.bounds
        
        imageView.layer.addSublayer(gradientLayer)
    }
}
