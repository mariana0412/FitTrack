//
//  ExerciseViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

final class ExerciseViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let attributesFont = UIFont(name: "Nunito-Light", size: 14)
        }
        enum RadialGradient {
            static let colors: [CGColor] = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.52).cgColor]
            static let locations: [NSNumber] = [0, 1]
            static let startPoint: CGPoint = CGPoint(x: 0.5, y: 0.5)
            static let endPoint: CGPoint = CGPoint(x: 1, y: 1)
        }
    }
    
    @IBOutlet private weak var exerciseImageView: UIImageView!
    @IBOutlet private weak var exerciseIconView: UIImageView!
    @IBOutlet private weak var exerciseName: UILabel!
    @IBOutlet private weak var exerciseAttributes: UILabel!
    @IBOutlet private weak var exerciseDescription: UILabel!
    
    var viewModel: ExerciseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ExerciseViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.exercise, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.exerciseViewController) as! ExerciseViewController
    }
    
    override func setBackgroundImage(named imageName: String) {}
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? "",
            backAction: #selector(backButtonTapped)
        )
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        exerciseName.textColor = .primaryWhite
        exerciseName.font = Fonts.sairaRegular18
        exerciseName.numberOfLines = 0
        
        exerciseAttributes.textColor = .primaryYellow
        exerciseAttributes.font = Constants.Layout.attributesFont
        exerciseAttributes.numberOfLines = 0
        
        exerciseDescription.textColor = .secondaryGray
        exerciseDescription.font = Fonts.sairaLight16
        GradientUtils.addRadialGradientLayer(to: exerciseImageView,
                                             colors: Constants.RadialGradient.colors,
                                             locations: Constants.RadialGradient.locations,
                                             startPoint: Constants.RadialGradient.startPoint,
                                             endPoint: Constants.RadialGradient.endPoint)
        
        setupReadMoreGesture()
    }
    
    private func bindViewModel() {
        if let exerciseImageName = viewModel?.exercise.exerciseImage {
            let exerciseImage = UIImage(named: exerciseImageName)
            exerciseImageView.image = exerciseImage
        }
        
        if let exerciseIconName = viewModel?.exercise.imageIcon {
            let exerciseIcon = UIImage(named: exerciseIconName)
            exerciseIconView.image = exerciseIcon
        }
        
        exerciseName.text = viewModel?.exercise.name
        exerciseAttributes.text = viewModel?.exercise.attributes
        exerciseDescription.text = viewModel?.exercise.descriptions
        exerciseDescription.numberOfLines = 4
            
        view.layoutIfNeeded()

        if let text = viewModel?.exercise.descriptions {
            exerciseDescription.text = text
            exerciseDescription.addReadMoreText(moreText: "...Read more", moreTextColor: .primaryYellow)
        }
    }

    private func setupReadMoreGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMoreTapped))
        exerciseDescription.isUserInteractionEnabled = true
        exerciseDescription.addGestureRecognizer(tapGesture)
    }

    @objc private func showMoreTapped() {
        exerciseDescription.numberOfLines = 0
        exerciseDescription.text = viewModel?.exercise.descriptions
        exerciseDescription.sizeToFit()
    }

    
    private func showFullText() {
        exerciseDescription.numberOfLines = 0
        exerciseDescription.text = viewModel?.exercise.descriptions
        exerciseDescription.sizeToFit()
    }

    
    @objc private func backButtonTapped() {
        viewModel?.navigateToMuscles()
    }
    
}

extension UILabel {
    func addReadMoreText(trailingText: String = " ", moreText: String = "...Read more", moreTextColor: UIColor, moreTextFont: UIFont? = nil) {
            let readMoreText = trailingText + moreText
            
            let labelWidth = self.frame.size.width
            let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
            let boundingRect = self.text?.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: [.font: self.font as Any], context: nil)
            let textHeight = boundingRect?.height ?? 0
            let lineHeight = self.font.lineHeight
            let maxLines = Int(textHeight / lineHeight)
            
            if maxLines <= 4 {
                self.text = self.text
                return
            }
            
            let visibleTextLength = self.visibleTextLength - 5
            guard visibleTextLength > 0, let text = self.text else { return }
            
            let mutableText = text as NSString
            let trimmedText = mutableText.replacingCharacters(in: NSRange(location: visibleTextLength, length: text.count - visibleTextLength), with: "")
            
            if trimmedText.count <= readMoreText.count { return }
            
            let trimmedForReadMore = (trimmedText as NSString).replacingCharacters(in: NSRange(location: trimmedText.count - readMoreText.count, length: readMoreText.count), with: "") + trailingText
            
            let attributedText = NSMutableAttributedString(string: trimmedForReadMore, attributes: [NSAttributedString.Key.font: self.font as Any])
            let readMoreAttributedText = NSMutableAttributedString(string: moreText, attributes: [NSAttributedString.Key.font: moreTextFont ?? self.font as Any, NSAttributedString.Key.foregroundColor: moreTextColor])
            
            attributedText.append(readMoreAttributedText)
            self.attributedText = attributedText
        }
    
    var visibleTextLength: Int {
        guard let text = self.text else { return 0 }
        let font = self.font
        let mode = self.lineBreakMode
        let labelWidth = self.frame.size.width
        let labelHeight = self.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        
        let attributes: [NSAttributedString.Key: Any] = [.font: font as Any]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let boundingRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        
        if boundingRect.size.height > labelHeight {
            var index = 0
            var prev = 0
            let characterSet = CharacterSet.whitespacesAndNewlines
            repeat {
                prev = index
                if mode == .byCharWrapping {
                    index += 1
                } else {
                    index = (text as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: text.count - index - 1)).location
                }
            } while index != NSNotFound && index < text.count && (text as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes, context: nil).size.height <= labelHeight
            return prev
        }
        return text.count
    }
}
