//
//  ExerciseViewController.swift
//  FitTrack
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

final class ExerciseViewController: BaseViewController {
    
    private enum Constants {
        enum Layout {
            static let attributesFont = UIFont(name: "Nunito-Light", size: 14)
            static let nameLinesNumber = 0
            static let attributesLinesNumber = 0
            static let descriptionMaxNumberOfLines = 4
            static let descriptionLinesNumber = 0
            static let showMoreButtonStyle = 1
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
    private var showMoreButton = CustomButton()
    
    var viewModel: ExerciseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupActions()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ExerciseViewController {
        return instantiate(fromStoryboard: StoryboardConstants.exercise,
                           viewControllerIdentifier: ViewControllerIdentifiers.exerciseViewController)
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
        exerciseName.numberOfLines = Constants.Layout.nameLinesNumber
        
        exerciseAttributes.textColor = .primaryYellow
        exerciseAttributes.font = Constants.Layout.attributesFont
        exerciseAttributes.numberOfLines = Constants.Layout.attributesLinesNumber
        
        exerciseDescription.textColor = .secondaryGray
        exerciseDescription.font = Fonts.sairaLight16
        
        showMoreButton.buttonStyle = Constants.Layout.showMoreButtonStyle
        showMoreButton.buttonTitle = viewModel?.showMoreButtonTitle
        showMoreButton.setupButtonFont(font: Fonts.sairaLight16, color: .primaryYellow)
        showMoreButton.sizeToFit()
        
        GradientUtils.addRadialGradientLayer(to: exerciseImageView,
                                             colors: Constants.RadialGradient.colors,
                                             locations: Constants.RadialGradient.locations,
                                             startPoint: Constants.RadialGradient.startPoint,
                                             endPoint: Constants.RadialGradient.endPoint)
    }
    
    private func setupActions() {
        exerciseDescription.isUserInteractionEnabled = true
        showMoreButton.addTarget(target, action: #selector(showMoreTapped), for: .touchUpInside)
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
            
        view.layoutIfNeeded()

        if let text = viewModel?.exercise.descriptions {
            exerciseDescription.text = text
            exerciseDescription.addShowMoreText(maxLinesNumber: Constants.Layout.descriptionMaxNumberOfLines,
                                                button: showMoreButton)
        }
    }

    @objc private func showMoreTapped() {
        showMoreButton.isHidden = true
        exerciseDescription.numberOfLines = Constants.Layout.descriptionLinesNumber
        exerciseDescription.text = viewModel?.exercise.descriptions
        exerciseDescription.sizeToFit()
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToMuscles()
    }
    
}
