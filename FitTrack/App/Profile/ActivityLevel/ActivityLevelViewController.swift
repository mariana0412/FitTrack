//
//  ActivityLevelViewController.swift
//  FitTrack
//
//  Created by Mariana Piz on 17.08.2024.
//

import UIKit

final class ActivityLevelViewController: UIViewController {
    
    private enum Constants {
        enum Layout {
            static let popupViewBorderWidth: CGFloat = 1.0
            static let popupViewCornerRadius: CGFloat = 8.0
            static let popupViewBorderColor = UIColor.primaryWhite.cgColor
            static let confirmButtonStyle = 0
        }
        
        enum TableView {
            static let cellReuseIdentifier = "ActivityLevelCell"
            static let rowHeight: CGFloat = 54
        }
    }
    
    @IBOutlet private weak var popupView: UIView!
    @IBOutlet private weak var chooseYourActivityLevelLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var confirmButton: CustomButton!
    
    private let overlayView = UIView()
    
    var viewModel: ActivityLevelViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        configureTableView()
        setupUI()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    static func instantiate() -> ActivityLevelViewController {
        return instantiate(fromStoryboard: StoryboardConstants.activityLevel,
                           viewControllerIdentifier: ViewControllerIdentifiers.activityLevelViewController)
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        let nib = UINib(nibName: Constants.TableView.cellReuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Constants.TableView.cellReuseIdentifier)
    }
    
    private func setupUI() {
        overlayView.backgroundColor = .clear
        overlayView.frame = view.bounds
        view.insertSubview(overlayView, belowSubview: popupView)
        
        popupView.layer.borderWidth = Constants.Layout.popupViewBorderWidth
        popupView.layer.cornerRadius = Constants.Layout.popupViewCornerRadius
        popupView.layer.borderColor = Constants.Layout.popupViewBorderColor
        
        chooseYourActivityLevelLabel.textColor = .primaryYellow
        chooseYourActivityLevelLabel.font = Fonts.sairaMedium18
        
        confirmButton.buttonStyle = Constants.Layout.confirmButtonStyle
        confirmButton.setupButtonFont(font: Fonts.sairaRegular16, color: .black)
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func backgroundTapped() {
        viewModel?.dismiss()
    }
    
    private func bindViewModel() {
        chooseYourActivityLevelLabel.text = viewModel?.chooseYourActivityLevelText
        confirmButton.buttonTitle = viewModel?.confirmButtonText
    }
    
    private func handleActivityLevelSelection(at indexPath: IndexPath) {
        guard let activityLevel = viewModel?.activityLevels[indexPath.row] else { return }
        
        viewModel?.handleActivityLevelSelection(for: activityLevel)
        tableView.reloadData()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        viewModel?.navigateToCalculator()
    }
    
}

extension ActivityLevelViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.activityLevels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.cellReuseIdentifier, for: indexPath) as! ActivityLevelCell
        
        if let activityLevel = viewModel?.activityLevels[indexPath.row] {
            let isSelected = viewModel?.isActivityLevelSelected(activityLevel) ?? false
            cell.configure(with: activityLevel, isSelected: isSelected)
            cell.delegate = self
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.TableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        handleActivityLevelSelection(at: indexPath)
    }
    
}

extension ActivityLevelViewController: ActivityLevelCellDelegate {
    func didTapRadiobutton(in cell: ActivityLevelCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        handleActivityLevelSelection(at: indexPath)
    }
}
