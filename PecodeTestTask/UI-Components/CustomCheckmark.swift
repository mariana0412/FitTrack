//
//  CustomCheckmark.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
class CustomCheckmarkButton: CustomToggleButton {
    
    init() {
        let selectedImage = UIImage(named: "customCheckmarkSelected")
        let unselectedImage = UIImage(named: "customCheckmark")
        super.init(selectedImage: selectedImage, unselectedImage: unselectedImage, size: CGSize(width: 16, height: 16))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selectedImage = UIImage(named: "customCheckmarkSelected")
        self.unselectedImage = UIImage(named: "customCheckmark")
        setup(size: CGSize(width: 16, height: 16))
    }
}

