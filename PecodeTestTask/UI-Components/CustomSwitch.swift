//
//  CustomSwitch.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 05.07.2024.
//

import UIKit

final class CustomSwitch: UISwitch {
    
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
        self.onTintColor = UIColor(named: ColorConstants.primaryYellow)
        self.thumbTintColor = UIColor(named: ColorConstants.primaryWhite)
        
        self.tintColor = UIColor(named: ColorConstants.secondaryGray)
        self.backgroundColor = UIColor(named: ColorConstants.secondaryGray)
        self.layer.cornerRadius = Constants.Layout.cornerRadius
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor(named: ColorConstants.primaryWhite)?.cgColor
        self.layer.borderWidth = Constants.Layout.borderWidth
    }
    
    private enum Constants {
        enum Layout {
            static let switchWidth: CGFloat = 74.0
            static let switchHeight: CGFloat = 33.0
            static let cornerRadius: CGFloat = switchHeight / 2
            static let borderWidth: CGFloat = 1.0
        }
    }
}
