//
//  CustomRadiobutton.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
class CustomRadiobutton: CustomToggleButton {
    
    init() {
        let selectedImage = UIImage(named: "radiobuttonFilled")
        let unselectedImage = UIImage(named: "radiobutton")
        super.init(selectedImage: selectedImage, unselectedImage: unselectedImage, size: CGSize(width: 15, height: 15))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selectedImage = UIImage(named: "radiobuttonFilled")
        self.unselectedImage = UIImage(named: "radiobutton")
        setup(size: CGSize(width: 15, height: 15))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.selectedImage = UIImage(named: "radiobuttonFilled")
        self.unselectedImage = UIImage(named: "radiobutton")
        setup(size: frame.size)
    }
}

