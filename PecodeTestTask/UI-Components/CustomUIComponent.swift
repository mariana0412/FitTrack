//
//  CustomUIComponent.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

class CustomUIComponent: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        setupView()
    }
    
    func setupView() {}
}
