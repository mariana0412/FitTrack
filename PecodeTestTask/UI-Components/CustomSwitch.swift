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
        self.onTintColor = UIColor(named: "PrimaryYellow")
        self.thumbTintColor = UIColor.white
        
        self.tintColor = UIColor(named: "SecondaryGray")
        self.backgroundColor = UIColor(named: "SecondaryGray")
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
    }
}
