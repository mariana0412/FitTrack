//
//  GradientImageView.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 07.07.2024.
//

import UIKit

class GradientImageView: UIImageView {

    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }
    
    private func addGradient() {
        layer.sublayers?.filter { $0 is CAGradientLayer }.forEach { $0.removeFromSuperlayer() }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.black.withAlphaComponent(0.8).cgColor,
            UIColor.black.withAlphaComponent(0.3).cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor,
            
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

