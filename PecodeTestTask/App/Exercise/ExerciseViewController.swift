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
        
        exerciseAttributes.textColor = .primaryYellow
        exerciseAttributes.font = Constants.Layout.attributesFont
        
        exerciseDescription.textColor = .secondaryGray
        exerciseDescription.font = Fonts.sairaLight16
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
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToMuscles()
    }
    
}
