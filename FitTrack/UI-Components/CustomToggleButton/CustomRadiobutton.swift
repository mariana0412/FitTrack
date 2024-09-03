//
//  CustomRadiobutton.swift
//  FitTrack
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
final class CustomRadiobutton: CustomToggleButton {
    
    private enum Constants {
        enum Layout {
            static let selectedImage = UIImage(named: "radiobuttonFilled")
            static let unselectedImage = UIImage(named: "radiobutton")
            static let size = CGSize(width: 15, height: 15)
        }
    }
    
    init() {
        let selectedImage = Constants.Layout.selectedImage
        let unselectedImage = Constants.Layout.unselectedImage
        super.init(selectedImage: selectedImage, unselectedImage: unselectedImage, size: Constants.Layout.size)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.selectedImage = Constants.Layout.selectedImage
        self.unselectedImage = Constants.Layout.unselectedImage
        setup(size: Constants.Layout.size)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.selectedImage = Constants.Layout.selectedImage
        self.unselectedImage = Constants.Layout.unselectedImage
        setup(size: frame.size)
    }

}

