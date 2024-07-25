//
//  CustomSwitch.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 05.07.2024.
//

import UIKit

final class CustomSwitch: UIControl {

    private enum Constants {
        enum Layout {
            static let borderWidth: CGFloat = 1.0
            static let thumbMargin: CGFloat = 2.0
            static let thumbShadowOpacity: Float = 0.2
            static let thumbShadowOffset: CGFloat = 1.0
            static let thumbShadowRadius: CGFloat = 1.0
            static let animationDuration: TimeInterval = 0.25
        }
        
        enum Colors {
            static let primaryYellow = UIColor.primaryYellow
            static let primaryGray = UIColor.primaryGray
            static let primaryWhite = UIColor.primaryWhite
        }
    }
    
    private var isOn: Bool = false
    private let thumbView = UIView()
    
    private let onColor = Constants.Colors.primaryYellow
    private let offColor = Constants.Colors.primaryGray
    private let borderColor = Constants.Colors.primaryWhite
    private let animationDuration: TimeInterval = Constants.Layout.animationDuration

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.backgroundColor = isOn ? onColor : offColor
        self.layer.cornerRadius = frame.height / 2
        self.layer.borderWidth = Constants.Layout.borderWidth
        self.layer.borderColor = borderColor.cgColor

        thumbView.backgroundColor = .white
        thumbView.layer.cornerRadius = (frame.height - Constants.Layout.thumbMargin * 2) / 2
        thumbView.layer.shadowColor = UIColor.black.cgColor
        thumbView.layer.shadowOpacity = Constants.Layout.thumbShadowOpacity
        thumbView.layer.shadowOffset = CGSize(width: 0.0, height: Constants.Layout.thumbShadowOffset)
        thumbView.layer.shadowRadius = Constants.Layout.thumbShadowRadius
        thumbView.isUserInteractionEnabled = false
        addSubview(thumbView)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(switchTapped))
        self.addGestureRecognizer(tapGesture)

        updateThumbPosition(animated: false)
    }

    private func updateThumbPosition(animated: Bool) {
        let margin = Constants.Layout.thumbMargin
        let thumbSize = CGSize(width: frame.height - margin * 2, height: frame.height - margin * 2)
        let thumbPosition = isOn ? frame.width - thumbSize.width - margin : margin

        let animations = {
            self.thumbView.frame = CGRect(x: thumbPosition, y: margin, width: thumbSize.width, height: thumbSize.height)
            self.backgroundColor = self.isOn ? self.onColor : self.offColor
        }

        if animated {
            UIView.animate(withDuration: self.animationDuration, animations: animations)
        } else {
            animations()
        }
    }

    @objc private func switchTapped() {
        setOn(!isOn, animated: true)
    }

    func setOn(_ on: Bool, animated: Bool) {
        isOn = on
        updateThumbPosition(animated: animated)
        sendActions(for: .valueChanged)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateThumbPosition(animated: false)
        self.layer.cornerRadius = frame.height / 2
        thumbView.layer.cornerRadius = (frame.height - Constants.Layout.thumbMargin * 2) / 2
    }
}
