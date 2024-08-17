//
//  CalculatorViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 14.08.2024.
//

import UIKit

final class CalculatorViewController: BaseViewController {
    
    private enum Constants {
        static let allowedCharacters = "0123456789."
        
        enum Fonts {
            static let calculatorTitleLabelFont = UIFont(name: "Saira-Medium", size: 24)
            static let resultValueFont = UIFont(name: "Saira-SemiBold", size: 28)
            static let resultValueFontError = UIFont(name: "Saira-Light", size: 18)
            static let resultValueDescriptionFont = UIFont(name: "Saira-Light", size: 18)
        }
        
        enum Layout {
            static let titleLabelToStackViewConstraint: CGFloat = 25
            static let resultViewToStackViewConstraint: CGFloat = 45
            static let chooseActivityLevelButtonBorderWidth: CGFloat = 1
            
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
    
    @IBOutlet private weak var heightInputView: MeasurementInputView!
    @IBOutlet private weak var weightInputView: MeasurementInputView!
    @IBOutlet private weak var neckInputView: MeasurementInputView!
    @IBOutlet private weak var waistInputView: MeasurementInputView!
    @IBOutlet private weak var hipsInputView: MeasurementInputView!
    @IBOutlet private weak var ageInputView: MeasurementInputView!
    
    @IBOutlet private weak var chooseActivityLevelButton: UIButton!
    
    @IBOutlet private weak var resultValueView: UIView!
    @IBOutlet private weak var resultValue: UILabel!
    @IBOutlet private weak var resultValueDescription: UILabel!
    
    @IBOutlet private weak var calculateButton: CustomButton!
    
    @IBOutlet private weak var titleLabelToStackViewConstraint: NSLayoutConstraint!
    @IBOutlet private weak var resultViewToStackViewConstraint: NSLayoutConstraint!
    
    var viewModel: CalculatorViewModel?
    
    var selectedActivityLevel: DailyCaloriesRateActivity? {
        didSet {
            if let newTitle = selectedActivityLevel?.rawValue {
                chooseActivityLevelButton.setTitle(newTitle, for: .normal)
                setNormalStateForActivityButton()
            }
        }
    }
    
    private var sex: UserSex = .male
    
    private lazy var inputViews: [MeasurementInputView] = [
        heightInputView,
        weightInputView,
        neckInputView,
        waistInputView,
        hipsInputView,
        ageInputView
    ]
    
    private var visibleInputViews: [MeasurementInputView] {
        return inputViews.filter { !$0.isHidden }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupDismissKeyboardOnTap()
        setupTextFieldDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        bindViewModel()
    }
    
    static func instantiate() -> CalculatorViewController {
        return instantiate(fromStoryboard: StoryboardConstants.calculator,
                           viewControllerIdentifier: ViewControllerIdentifiers.calculatorViewController)
    }
   
    private func setupUI() {
        calculatorTitleLabel.font = Constants.Fonts.calculatorTitleLabelFont
        calculatorTitleLabel.textColor = .primaryWhite
        
        chooseActivityLevelButton.layer.borderWidth = Constants.Layout.chooseActivityLevelButtonBorderWidth
        chooseActivityLevelButton.layer.cornerRadius = chooseActivityLevelButton.frame.height / 2
        chooseActivityLevelButton.backgroundColor = .clear
        chooseActivityLevelButton.titleLabel?.lineBreakMode = .byTruncatingTail
        setNormalStateForActivityButton()
        
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
        
        if viewModel.type == .dailyCalorieRequirement {
            chooseActivityLevelButton.setTitle(viewModel.chooseActivityLevelButtonTitle, for: .normal)
        } else {
            chooseActivityLevelButton.removeFromSuperview()
            resultViewToStackViewConstraint.constant = Constants.Layout.resultViewToStackViewConstraint
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
    
    @IBAction private func calculateButtonTapped(_ sender: Any) {
        resetInputFieldStates()
        
        guard let viewModel else { return }
        
        let inputFieldMapping = createInputFieldMapping()

        let values = gatherInputValues(inputFieldMapping: inputFieldMapping)
        let (invalidFields, validatedValues) = viewModel.validateInputs(values: values)
        
        let validationIsSuccessful = invalidFields.isEmpty
        if !validationIsSuccessful {
            setErrorStateForResult()
            setErrorStateForInvalidFields(invalidFields, inputFieldMapping: inputFieldMapping)
        }
        
        let activityLevelIsInvalid = viewModel.type == .dailyCalorieRequirement && selectedActivityLevel == nil
        if activityLevelIsInvalid {
            setErrorStateForActivityButton()
            setErrorStateForResult()
        }
        
        if validationIsSuccessful && !activityLevelIsInvalid {
            let (result, description) = viewModel.calculate(values: validatedValues,
                                                            sex: sex, 
                                                            activityLevel: selectedActivityLevel)
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
    
    private func setErrorStateForInvalidFields(_ fields: [CalculatorViewModel.InputField],
                                        inputFieldMapping: [CalculatorViewModel.InputField: MeasurementInputView]) {
        for field in fields {
            inputFieldMapping[field]?.currentState = .error
        }
    }
    
    private func setNormalStateForActivityButton() {
        chooseActivityLevelButton.setTitleColor(.primaryWhite, for: .normal)
        chooseActivityLevelButton.layer.borderColor = UIColor.primaryWhite.cgColor
    }
    
    private func setErrorStateForActivityButton() {
        chooseActivityLevelButton.layer.borderColor = UIColor.primaryRed.cgColor
        chooseActivityLevelButton.setTitleColor(.primaryRed, for: .normal)
    }
    
    private func setErrorStateForResult() {
        resultValueView.layer.borderColor = Constants.Layout.ResultValueView.borderColorError
        resultValue.font = Constants.Fonts.resultValueFontError
        resultValue.textColor = .primaryRed
        resultValue.text = viewModel?.resultErrorMessage
        resultValueView.isHidden = false
        resultValueDescription.isHidden = true
        resultValueView.setNeedsLayout()
        resultValueView.layoutIfNeeded()

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
    
    private func setupTextFieldDelegates() {
        for inputView in visibleInputViews {
            inputView.textField.delegate = self
            inputView.textField.keyboardType = .numbersAndPunctuation
        }
        
        for (index, inputView) in visibleInputViews.enumerated() {
            inputView.textField.returnKeyType = (index == visibleInputViews.count - 1) ? .done : .next
        }
    }
    
    @IBAction private func chooseActivityLevelButtonClicked(_ sender: Any) {
        viewModel?.navigateToActivityLevel(selectedActivityLevel: selectedActivityLevel)
    }
    
}

extension CalculatorViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard var index = indexOfInputView(containing: textField) else { return false }
        
        index += 1
        if index < visibleInputViews.count {
            visibleInputViews[index].textField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let inputViewIndex = indexOfInputView(containing: textField) else { return }
        visibleInputViews[inputViewIndex].currentState = .active
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.isEmpty {
            return true
        }

        let allowedCharacters = CharacterSet(charactersIn: Constants.allowedCharacters)
        let characterSet = CharacterSet(charactersIn: string)
        
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    private func indexOfInputView(containing textField: UITextField) -> Int? {
        visibleInputViews.firstIndex(where: { $0.textField == textField })
    }
    
}
