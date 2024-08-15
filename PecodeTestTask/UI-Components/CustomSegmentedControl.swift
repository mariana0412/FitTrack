//
//  CustomSegmentedControl.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 15.08.2024.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    private enum Constants {
        static let defaultNumberOfSegments: Int = 2
        static let defaultSegmentsTitle: String = "Segment 1,Segment 2"
        static let animationDuration: TimeInterval = 0.3
        
        enum Layout {
            static let defaultCornerRadius: CGFloat = 15
            static let defaultButtonCornerRadius: CGFloat = 10
            static let defaultBorderWidth: CGFloat = 1
        }
    }
    
    var stackView: UIStackView = UIStackView()
    var buttonsCollection: [UIButton] = []
    var currentIndexView: UIView = UIView(frame: .zero)
    
    var buttonPadding: CGFloat = 0
    var stackViewSpacing: CGFloat = 0
    
    var didTapSegment: ((Int) -> ())?
    
    @IBInspectable var currentIndex: Int = 0 {
        didSet {
            setCurrentIndex()
        }
    }
    
    @IBInspectable var currentIndexTitleColor: UIColor = .black {
        didSet {
            updateTextColors()
        }
    }
    
    @IBInspectable var currentIndexBackgroundColor: UIColor = .primaryYellow {
        didSet {
            setCurrentViewBackgroundColor()
        }
    }
    
    @IBInspectable var otherIndexTitleColor: UIColor = .primaryYellow {
        didSet {
            updateTextColors()
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = Constants.Layout.defaultCornerRadius {
        didSet {
            setCornerRadius()
        }
    }
    
    @IBInspectable var buttonCornerRadius: CGFloat = Constants.Layout.defaultButtonCornerRadius {
        didSet {
            setButtonCornerRadius()
        }
    }
    
    @IBInspectable var borderColor: UIColor = .primaryYellow {
        didSet {
            setBorderColor()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = Constants.Layout.defaultBorderWidth {
        didSet {
            setBorderWidth()
        }
    }
    
    @IBInspectable var numberOfSegments: Int = Constants.defaultNumberOfSegments {
        didSet {
            addSegments()
        }
    }
    
    @IBInspectable var segmentsTitle: String = Constants.defaultSegmentsTitle {
        didSet {
            updateSegmentTitles()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setCurrentIndex()
    }
    
    private func commonInit() {
        backgroundColor = .clear
        
        setupStackView()
        addSegments()
        setCurrentIndexView()
        setCurrentIndex(animated: false)
        
        setCornerRadius()
        setButtonCornerRadius()
        setBorderColor()
        setBorderWidth()
    }
    
    private func setCurrentIndexView() {
        setCurrentViewBackgroundColor()
        
        addSubview(currentIndexView)
        sendSubviewToBack(currentIndexView)
    }
    
    private func setCurrentIndex(animated: Bool = true) {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                let buttonWidth = (frame.width - (buttonPadding * 2)) / CGFloat(numberOfSegments)
                
                if animated {
                    UIView.animate(withDuration: Constants.animationDuration) {
                        self.currentIndexView.frame =
                            CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                               y: self.buttonPadding,
                               width: buttonWidth,
                               height: self.frame.height - (self.buttonPadding * 2))
                    }
                } else {
                    self.currentIndexView.frame =
                        CGRect(x: self.buttonPadding + (buttonWidth * CGFloat(index)),
                           y: self.buttonPadding,
                           width: buttonWidth,
                           height: self.frame.height - (self.buttonPadding * 2))
                }
                
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
    }
    
    private func updateTextColors() {
        stackView.subviews.enumerated().forEach { (index, view) in
            let button: UIButton? = view as? UIButton
            
            if index == currentIndex {
                button?.setTitleColor(currentIndexTitleColor, for: .normal)
            } else {
                button?.setTitleColor(otherIndexTitleColor, for: .normal)
            }
        }
    }
    
    private func setCurrentViewBackgroundColor() {
        currentIndexView.backgroundColor = currentIndexBackgroundColor
    }
    
    private func setupStackView() {
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = stackViewSpacing
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: buttonPadding),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -buttonPadding),
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: buttonPadding),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -buttonPadding)
            ]
        )
    }
    
    private func addSegments() {
        buttonsCollection.removeAll()
        stackView.subviews.forEach { view in
            (view as? UIButton)?.removeFromSuperview()
        }

        let titles = segmentsTitle.split(separator: ",")
        
        for index in 0 ..< numberOfSegments {
            let button = UIButton()
            button.tag = index
            
            if let index = titles.indices.contains(index) ? index : nil {
                button.setTitle(String(titles[index]), for: .normal)
            } else {
                button.setTitle("<Segment>", for: .normal)
            }
            
            button.titleLabel?.font = Fonts.helveticaNeue18
            button.addTarget(self, action: #selector(segmentTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
            buttonsCollection.append(button)
        }
    }
    
    private func updateSegmentTitles() {
        let titles = segmentsTitle.split(separator: ",")
        
        stackView.subviews.enumerated().forEach { (index, view) in
            if let index = titles.indices.contains(index) ? index : nil {
                (view as? UIButton)?.setTitle(String(titles[index]), for: .normal)
            } else {
                (view as? UIButton)?.setTitle("<Segment>", for: .normal)
            }
        }
    }
    
    private func setCornerRadius() {
        layer.cornerRadius = cornerRadius
    }
    
    private func setButtonCornerRadius() {
        stackView.subviews.forEach { view in
            (view as? UIButton)?.layer.cornerRadius = cornerRadius
        }
        
        currentIndexView.layer.cornerRadius = cornerRadius
        currentIndexView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    private func switchCurrentIndexViewMaskedCorners() {
        if currentIndexView.layer.maskedCorners == [.layerMinXMinYCorner, .layerMinXMaxYCorner] {
            currentIndexView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        } else {
            currentIndexView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    private func setBorderColor() {
        layer.borderColor = borderColor.cgColor
    }
    
    private func setBorderWidth() {
        layer.borderWidth = borderWidth
    }
    
    @objc func segmentTapped(_ sender: UIButton) {
        let prevIndex = currentIndex
        currentIndex = sender.tag
        if prevIndex != currentIndex {
            didTapSegment?(sender.tag)
            switchCurrentIndexViewMaskedCorners()
        }
    }
    
}
