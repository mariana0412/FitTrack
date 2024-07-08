//
//  OverlayUtils.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class OverlayUtils {
    static func addDarkOverlay(to imageView: UIImageView, color: UIColor, opacity: CGFloat) {
        let overlayView = UIView(frame: imageView.bounds)
        overlayView.backgroundColor = color
        overlayView.alpha = opacity
        
        imageView.addSubview(overlayView)
    }
}
