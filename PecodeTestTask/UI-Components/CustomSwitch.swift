//
//  CustomSwitch.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 05.07.2024.
//

import UIKit

final class CustomSwitch: UISwitch {
    
    private enum Constants {
        enum Layout {
            static let switchWidth: CGFloat = 74.0
            static let switchHeight: CGFloat = 33.0
            static let cornerRadius: CGFloat = switchHeight / 2
            static let borderWidth: CGFloat = 1.0
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: Constants.Layout.switchWidth, height: Constants.Layout.switchHeight))
        customizeSwitch()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frame = CGRect(x: 0, y: 0, width: Constants.Layout.switchWidth, height: Constants.Layout.switchHeight)
        customizeSwitch()
    }
    
    private func customizeSwitch() {
        self.onTintColor = UIColor.primaryYellow
        self.thumbTintColor = UIColor.primaryWhite
        
        self.tintColor = UIColor.secondaryGray
        self.backgroundColor = UIColor.secondaryGray
        self.layer.cornerRadius = Constants.Layout.cornerRadius
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.primaryWhite.cgColor
        self.layer.borderWidth = Constants.Layout.borderWidth
    }
    
}
