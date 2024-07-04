//
//  CustomToggleButton.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 04.07.2024.
//

import UIKit

@IBDesignable
class CustomToggleButton: CustomUIComponent {
    
    var selectedImage: UIImage?
    var unselectedImage: UIImage?
    private var button: UIButton!
    
    init(selectedImage: UIImage?, unselectedImage: UIImage?, size: CGSize) {
        self.selectedImage = selectedImage
        self.unselectedImage = unselectedImage
        super.init(frame: .zero)
        setup(size: size)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setup(size: CGSize) {
        setupView(size: size)
        self.backgroundColor = .clear
    }
    
    func setupView(size: CGSize) {
        super.setupView()
        
        button = UIButton(type: .custom)
        
        var config = UIButton.Configuration.plain()
        config.image = unselectedImage
        config.baseBackgroundColor = .clear
        
        button.configuration = config
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            var updatedConfig = button.configuration
            updatedConfig?.image = button.isSelected ? self.selectedImage : self.unselectedImage
            updatedConfig?.baseBackgroundColor = .clear
            button.configuration = updatedConfig
        }
        
        button.addTarget(self, action: #selector(toggleSelection), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: size.width),
            button.heightAnchor.constraint(equalToConstant: size.height)
        ])
    }
    
    @objc private func toggleSelection() {
        button.isSelected.toggle()
    }
}
