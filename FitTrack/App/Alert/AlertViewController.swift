//
//  AlertViewController.swift
//  FitTrack
//
//  Created by Mariana Piz on 22.07.2024.
//

import UIKit

final class AlertViewController: UIViewController {
    
    private enum Constants {
        enum Layout {
            static let contentViewBackgroundColor = UIColor.black.withAlphaComponent(0.7)
            
            static let alertViewBackgroundColor = UIColor.black
            static let alertViewBorderWidth: CGFloat = 1.0
            static let alertViewCornerRadius: CGFloat = 8.0
            static let alertViewBorderColor = UIColor.primaryWhite.cgColor
            
            static let messageNumberOfLines = 0
            
            static let buttonWidth: CGFloat = 129
        }
        
        enum Animation {
            static let presentDuration: TimeInterval = 0.7
            static let presentDelay: TimeInterval = 0
            static let presentSpringDamping: CGFloat = 0.8
            static let presentInitialSpringVelocity: CGFloat = 0.1
            static let presentOptions: UIView.AnimationOptions = .curveEaseInOut
            
            static let dismissDuration: TimeInterval = 0.3
            
            static let noButtonsDismissDelay: TimeInterval = 2.0
        }
        
    }
    
    @IBOutlet private weak var alertView: UIView!
    @IBOutlet private weak var messageLabel: UILabel!
    @IBOutlet private weak var buttonsContainer: UIStackView!
    @IBOutlet private weak var okButton: CustomButton!
    @IBOutlet private weak var cancelButton: CustomButton!

    private let overlayView = UIView()
    
    var viewModel: AlertViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
        setupGestures()
    }
    
    static func instantiate() -> AlertViewController {
        return instantiate(fromStoryboard: StoryboardConstants.alert,
                           viewControllerIdentifier: ViewControllerIdentifiers.alertViewController)
    }
    
    private func setupUI() {
        view.backgroundColor = Constants.Layout.contentViewBackgroundColor
        
        overlayView.backgroundColor = .clear
        overlayView.frame = view.bounds
        view.insertSubview(overlayView, belowSubview: alertView)
        
        alertView.backgroundColor = Constants.Layout.alertViewBackgroundColor
        alertView.layer.borderWidth = Constants.Layout.alertViewBorderWidth
        alertView.layer.cornerRadius = Constants.Layout.alertViewCornerRadius
        alertView.layer.borderColor = Constants.Layout.alertViewBorderColor
        
        messageLabel.font = Fonts.helveticaNeue16
        messageLabel.textColor = .primaryWhite
        messageLabel.numberOfLines = Constants.Layout.messageNumberOfLines
        
        okButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
        okButton.widthAnchor.constraint(equalToConstant: Constants.Layout.buttonWidth).isActive = true
        cancelButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
    }
    
    private func bindViewModel() {
        guard let viewModel = viewModel else { return }
        switch viewModel.alertContent.alertType {
        case .twoButtons:
            messageLabel.text = viewModel.alertContent.message
            
            if let okButtonTitle = viewModel.alertContent.okButtonTitle {
                okButton.buttonTitle = okButtonTitle
                okButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
                okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
            }
            if let cancelButtonTitle = viewModel.alertContent.cancelButtonTitle {
                cancelButton.buttonTitle = cancelButtonTitle
                cancelButton.setupButtonFont(font: Fonts.sairaMedium16, color: .primaryYellow)
                cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
            }
            
        case .oneButton:
            messageLabel.text = viewModel.alertContent.message
            
            cancelButton.isHidden = true
            self.buttonsContainer.modify(forAxis: .vertical,
                                         alignment: .center,
                                         distribution: .fillProportionally)
            
            if let okButtonTitle = viewModel.alertContent.okButtonTitle {
                okButton.buttonTitle = okButtonTitle
                okButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
                okButton.addTarget(self, action: #selector(okButtonTapped), for: .touchUpInside)
            }
            
        case .noButtons:
            let message = viewModel.alertContent.message
            messageLabel.attributedText = createAttributedString(with: message, icon: viewModel.alertContent.icon ?? UIImage())
            
            buttonsContainer.isHidden = true
            messageLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                messageLabel.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
            ])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.noButtonsDismissDelay) { [weak self] in
                self?.animateOut {
                    self?.dismiss(animated: false, completion: nil)
                }
            }
        }
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func okButtonTapped() {
        animateOut { [weak self] in
            self?.viewModel?.alertContent.okClickedAction?()
        }
    }
    
    @objc private func cancelButtonTapped() {
        animateOut { [weak self] in
            self?.viewModel?.alertContent.cancelClickedAction?()
        }
    }
    
    @objc private func backgroundTapped() {
        animateOut { [weak self] in
            self?.dismiss(animated: false, completion: nil)
        }
    }

    func animateIn() {
        alertView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        UIView.animate(withDuration: Constants.Animation.presentDuration,
                       delay: Constants.Animation.presentDelay,
                       usingSpringWithDamping: Constants.Animation.presentSpringDamping,
                       initialSpringVelocity: Constants.Animation.presentInitialSpringVelocity,
                       options: Constants.Animation.presentOptions,
                       animations: {
                            self.alertView.transform = .identity
                        }, completion: nil)
    }
    
    private func animateOut(completion: @escaping () -> Void) {
        UIView.animate(withDuration: Constants.Animation.dismissDuration,
                       animations: {
            self.alertView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }, completion: { _ in
            self.dismiss(animated: false, completion: completion)
        })
    }
    
    private func createAttributedString(with message: String, icon: UIImage) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        let attachment = NSTextAttachment()
        attachment.image = icon
        let imageString = NSAttributedString(attachment: attachment)
        
        attributedString.append(imageString)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(NSAttributedString(string: message))
        
        return attributedString
    }
    
}
