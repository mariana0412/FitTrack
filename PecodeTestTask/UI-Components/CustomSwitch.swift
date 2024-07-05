//
//  CustomSwitch.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 05.07.2024.
//

import UIKit

class CustomSwitch: UISwitch {
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 74, height: 33))
        customizeSwitch()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.frame = CGRect(x: 0, y: 0, width: 74, height: 33)
        customizeSwitch()
    }
    
    private func customizeSwitch() {
        self.onTintColor = UIColor(named: ColorConstants.primaryYellow)
        self.thumbTintColor = UIColor(named: ColorConstants.primaryWhite)
        
        self.tintColor = UIColor(named: ColorConstants.secondaryGray)
        self.backgroundColor = UIColor(named: ColorConstants.secondaryGray)
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor(named: ColorConstants.primaryWhite)?.cgColor
        self.layer.borderWidth = 1
    }
}
