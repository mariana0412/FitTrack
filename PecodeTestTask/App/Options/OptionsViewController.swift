//
//  OptionsViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

import UIKit

final class OptionsViewController: UIViewController {
    
    private enum Constants {
        enum Popup {
            static let popupViewBorderWidth: CGFloat = 1.0
            static let popupViewCornerRadius: CGFloat = 8.0
            static let popupViewBorderColor = UIColor.primaryWhite.cgColor
        }
        
        enum TableView {
            static let cellReuseIdentifier = "OptionCell"
            static let rowHeight: CGFloat = 38
        }
    }
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var addOptionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var selectButton: CustomButton!
    
    var viewModel: OptionsViewModel?
    
    private var optionsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureTableView()
        setupUI()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    static func instantiate() -> OptionsViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.options, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.optionsViewController) as! OptionsViewController
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: Constants.TableView.cellReuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.TableView.cellReuseIdentifier)
    }
    
    private func setupUI() {
        popupView.layer.borderWidth = Constants.Popup.popupViewBorderWidth
        popupView.layer.cornerRadius = Constants.Popup.popupViewCornerRadius
        popupView.layer.borderColor = Constants.Popup.popupViewBorderColor
        
        addOptionsLabel.textColor = .primaryYellow
        addOptionsLabel.font = Fonts.sairaMedium18

        cancelButton.setupButtonFont(font: Fonts.sairaRegular18, color: .primaryWhite)
        
        selectButton.setupButtonFont(font: Fonts.sairaRegular18, color: .primaryYellow)
    }
    
    private func bindViewModel() {
        addOptionsLabel.text = viewModel?.selectOptionText
        cancelButton.buttonTitle = viewModel?.cancelButtonText
        selectButton.buttonTitle = viewModel?.selectButtonText
    }
    
    private func setupActions() {
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        selectButton.addTarget(self, action: #selector(selectButtonTapped), for: .touchUpInside)
    }
    
    private func handleOptionSelection(at indexPath: IndexPath) {
        guard let option = viewModel?.options[indexPath.row] else { return }
        
        viewModel?.handleOptionSelection(for: option)
        optionsChanged = true
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    @objc private func cancelButtonTapped() {
        viewModel?.navigateToProfile()
    }
    
    @objc private func selectButtonTapped() {
        if optionsChanged {
            viewModel?.navigateToProfileWithChanges()
        } else {
            viewModel?.navigateToProfile()
        }
    }
    
}

extension OptionsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.cellReuseIdentifier, for: indexPath) as! OptionCell
        
        if let option = viewModel?.options[indexPath.row] {
            let isSelected = viewModel?.isOptionSelected(option) ?? false
            cell.configure(with: option, isSelected: isSelected)
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.TableView.rowHeight
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.TableView.rowHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleOptionSelection(at: indexPath)
    }
    
}

extension OptionsViewController: OptionCellDelegate {
    
    func didTapCheckmark(in cell: OptionCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        handleOptionSelection(at: indexPath)
    }

}
