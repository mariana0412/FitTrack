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
            static let resultValueFontError = UIFont(name: "Saira-Light", size: 18)
            static let resultValueDescriptionFont = UIFont(name: "Saira-Light", size: 18)
        }
        
        enum Layout {
            static let titleLabelToStackViewConstraint: CGFloat = 25
            
            enum ResultValueView {
                static let cornerRadius: CGFloat = 8
                static let borderWidth: CGFloat = 1
                static let borderColor: CGColor = UIColor.primaryWhite.withAlphaComponent(0.4).cgColor
                
                static let borderColorError: CGColor = UIColor.primaryRed.withAlphaComponent(0.4).cgColor
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
    @IBOutlet private weak var hipsInputView: MeasurementInputView!
    @IBOutlet private weak var ageInputView: MeasurementInputView!
    
    @IBOutlet private weak var resultValueView: UIView!
    @IBOutlet private weak var resultValue: UILabel!
    @IBOutlet private weak var resultValueDescription: UILabel!
    
    @IBOutlet private weak var calculateButton: CustomButton!
    
    @IBOutlet private weak var titleLabelToStackViewConstraint: NSLayoutConstraint!
    
    var viewModel: CalculatorViewModel?
    var sex: UserSex = .male
    
    private lazy var inputViews: [MeasurementInputView] = [
        heightInputView,
        weightInputView,
        neckInputView,
        waistInputView,
        hipsInputView,
        ageInputView
    ]
    
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
        
        resultValueDescription.font = Constants.Fonts.resultValueDescriptionFont
        resultValueDescription.textColor = .primaryWhite
        
        hideResult()
        
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
                self?.hideResult()
            }
        }
        
        calculateButton.buttonTitle = viewModel.calculateButtonTitle
        
        updateInputViews()
    }
    
    private func updateInputViews() {
        guard let viewModel = viewModel else { return }

        let inputFieldMapping = createInputFieldMapping()
        
        for (field, config) in viewModel.configurations(sex: sex) {
            guard let inputView = inputFieldMapping[field] else { continue }
            
            inputView.isHidden = config.isHidden
            
            if let title = config.title, let unit = config.unit {
                inputView.configure(title: title, unit: unit)
            }
        }
    }

    private func switchSex() {
        sex = (sex == .male) ? .female : .male
        if viewModel?.type == .fatPercentage {
            updateInputViews()
        }
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
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        guard let viewModel else { return }
        
        let inputFieldMapping = createInputFieldMapping()

        let values = gatherInputValues(inputFieldMapping: inputFieldMapping)
        let invalidFields = viewModel.validateInputs(values: values)
        
        resetInputFieldStates()
        highlightInvalidFields(invalidFields, inputFieldMapping: inputFieldMapping)
        
        let validationIsSuccessful = invalidFields.isEmpty
        if validationIsSuccessful {
            let (result, description) = viewModel.calculate(values: values, sex: sex)
            setNormalStateForResult(result: result, description: description)
        }
    }
    
    private func gatherInputValues(inputFieldMapping: [CalculatorViewModel.InputField: MeasurementInputView]) -> [CalculatorViewModel.InputField: String?] {
        var values: [CalculatorViewModel.InputField: String?] = [:]
        
        for (field, inputView) in inputFieldMapping {
            if !inputView.isHidden {
                values[field] = inputView.textFieldText
            }
        }
        
        return values
    }
    
    private func resetInputFieldStates() {
        for inputView in inputViews {
            inputView.currentState = .normal
        }
    }
    
    private func highlightInvalidFields(_ fields: [CalculatorViewModel.InputField],
                                        inputFieldMapping: [CalculatorViewModel.InputField: MeasurementInputView]) {
        for field in fields {
            inputFieldMapping[field]?.currentState = .error
        }
        
        setErrorStateForResult()
    }
    
    private func setErrorStateForResult() {
        resultValueView.layer.borderColor = Constants.Layout.ResultValueView.borderColorError
        resultValue.font = Constants.Fonts.resultValueFontError
        resultValue.textColor = .primaryRed
        resultValue.text = viewModel?.resultErrorMessage
        resultValueView.isHidden = false
        resultValueDescription.isHidden = true
    }
    
    private func setNormalStateForResult(result: String, description: String) {
        resultValue.font = Constants.Fonts.resultValueFont
        resultValue.textColor = .primaryYellow
        resultValue.text = result
        
        resultValueView.layer.borderColor = Constants.Layout.ResultValueView.borderColor
        resultValueView.isHidden = false
        
        resultValueDescription.text = description
        resultValueDescription.isHidden = false
    }
    
    private func hideResult() {
        resultValueView.isHidden = true
        resultValueDescription.isHidden = true
    }
    
    private func createInputFieldMapping() -> [CalculatorViewModel.InputField: MeasurementInputView] {
        [
            .height: heightInputView,
            .weight: weightInputView,
            .neck: neckInputView,
            .waist: waistInputView,
            .hips: hipsInputView,
            .age: ageInputView
        ]
    }
}
