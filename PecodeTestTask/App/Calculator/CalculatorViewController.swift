//
//  CalculatorViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//

import UIKit

final class CalculatorViewController: BaseViewController {
    
    private enum Constants {
        enum Fonts {
            static let calculatorTitleLabelFont = UIFont(name: "Saira-Medium", size: 24)
            static let resultValueFont = UIFont(name: "Saira-SemiBold", size: 28)
            static let resultValueDescriptionFont = UIFont(name: "Saira-Light", size: 18)
        }
        
        enum Layout {
            static let titleLabelToStackViewConstraint: CGFloat = 25
            
            enum ResultValueView {
                static let cornerRadius: CGFloat = 8
                static let borderWidth: CGFloat = 1
                static let borderColor: CGColor = UIColor.primaryWhite.withAlphaComponent(0.4).cgColor
            }
        }
    }
    
    @IBOutlet private weak var calculatorTitleLabel: UILabel!
    
    @IBOutlet private weak var segmentedControl: CustomSegmentedControl!
    
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var heightInputView: MeasurementInputView!
    @IBOutlet private weak var weightInputView: MeasurementInputView!
    @IBOutlet private weak var neckInputView: MeasurementInputView!
    @IBOutlet private weak var waistInputView: MeasurementInputView!
    @IBOutlet private weak var ageInputView: MeasurementInputView!
    
    @IBOutlet private weak var resultValueView: UIView!
    @IBOutlet private weak var resultValue: UILabel!
    @IBOutlet private weak var resultValueDescription: UILabel!
    
    @IBOutlet private weak var calculateButton: CustomButton!
    
    @IBOutlet private weak var titleLabelToStackViewConstraint: NSLayoutConstraint!
    
    var viewModel: CalculatorViewModel?
    var sex: UserSex = .male
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        bindViewModel()
    }
    
    static func instantiate() -> CalculatorViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.calculator, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.calculatorViewController) as! CalculatorViewController
    }
   
    private func setupUI() {
        calculatorTitleLabel.font = Constants.Fonts.calculatorTitleLabelFont
        calculatorTitleLabel.textColor = .primaryWhite
        
        resultValueView.layer.cornerRadius = Constants.Layout.ResultValueView.cornerRadius
        resultValueView.layer.borderWidth = Constants.Layout.ResultValueView.borderWidth
        resultValueView.layer.borderColor = Constants.Layout.ResultValueView.borderColor
        resultValueView.isHidden = true
        
        resultValue.font = Constants.Fonts.resultValueFont
        resultValue.textColor = .primaryYellow
        
        resultValueDescription.font = Constants.Fonts.resultValueDescriptionFont
        resultValueDescription.textColor = .primaryWhite
        resultValueDescription.isHidden = true
        
        calculateButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
    }
    
    private func bindViewModel() {
        guard let viewModel else { return }
        
        calculatorTitleLabel.text = viewModel.type.rawValue
        
        if viewModel.type == .bodyMassIndex {
            segmentedControl.removeFromSuperview()
            titleLabelToStackViewConstraint.constant = Constants.Layout.titleLabelToStackViewConstraint
        } else {
            segmentedControl.segmentsTitle = viewModel.segmentedControlTitles
            segmentedControl.didTapSegment = { [weak self] index in
                self?.switchSex()
            }
        }
        
        calculateButton.buttonTitle = viewModel.calculateButtonTitle
        
        let inputViews: [CalculatorType.InputField: MeasurementInputView] = [
            .height: heightInputView,
            .weight: weightInputView,
            .neck: neckInputView,
            .waist: waistInputView,
            .age: ageInputView
        ]

        for (field, config) in viewModel.type.сonfigurations {
            if let inputView = inputViews[field] {
                inputView.isHidden = config.isHidden
                if let title = config.title,
                   let unit = config.unit {
                    inputView.configure(title: title, unit: unit)
                }
            }
        }
    }
    
    private func switchSex() {
        sex = (sex == .male) ? .female : .male
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationBarTitle ?? "",
            backAction: #selector(backButtonTapped)
        )
    }
    
    @objc private func backButtonTapped() {
        viewModel?.navigateToCalculatorSelection()
    }
    
}
