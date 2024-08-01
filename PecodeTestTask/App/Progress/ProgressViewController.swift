//
//  ProgressViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

final class ProgressViewController: BaseViewController {
    
    private enum Constants {
        enum TableView {
            static let cellReuseIdentifier = "optionNameCell"
        }
        enum Layout {
            static let noOptionsViewBorderWidth: CGFloat = 1.0
            static let noOptionsViewCornerRadius: CGFloat = 8.0
            static let noOptionsViewBorderColor = UIColor.primaryWhite.cgColor
            static let icon = UIImage(systemName: "exclamationmark.circle")
        }
    }
    
    @IBOutlet weak var noOptionsView: UIView!
    @IBOutlet weak var exclamationMarkIcon: UIImageView!
    @IBOutlet weak var noOptionsLabel: UILabel!
    @IBOutlet weak var optionsTableView: UITableView!
    
    var viewModel: ProgressViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configureTableView()
        loadOptions()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleProfileUpdate(_:)), name: .profileDidUpdate, object: nil)
    }

    @objc private func handleProfileUpdate(_ notification: Notification) {
        if let userInfo = notification.userInfo, let updatedUser = userInfo["user"] as? UserData {
            viewModel?.updateOptions(with: updatedUser.selectedOptions)
            optionsTableView.reloadData()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .profileDidUpdate, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> ProgressViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.progress, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.progressViewController) as! ProgressViewController
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? ""
        )
    }
    
    private func loadOptions() {
        viewModel?.fetchUser { [weak self] errorMessage in
            if let errorMessage = errorMessage {
                print("Error: \(errorMessage)")
            }
            self?.setupUI()
        }
    }
    
    private func setupUI() {
        noOptionsView.layer.borderWidth = Constants.Layout.noOptionsViewBorderWidth
        noOptionsView.layer.cornerRadius = Constants.Layout.noOptionsViewCornerRadius
        noOptionsView.layer.borderColor = Constants.Layout.noOptionsViewBorderColor
        
        noOptionsLabel.text = viewModel?.noOptionsText
        noOptionsLabel.font = Fonts.helveticaNeue16
        noOptionsLabel.textColor = .primaryWhite
        
        exclamationMarkIcon.image = Constants.Layout.icon
        exclamationMarkIcon.tintColor = .primaryYellow
        
        if viewModel?.options.isEmpty == true {
            optionsTableView.isHidden = true
        } else {
            noOptionsView.isHidden = true
            optionsTableView.reloadData()
        }
    }
    
    private func configureTableView() {
        optionsTableView.dataSource = self
        optionsTableView.delegate = self
        optionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.TableView.cellReuseIdentifier)
    }
    
}

extension ProgressViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.options.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.cellReuseIdentifier,
                                                 for: indexPath)
        if let option = viewModel?.options[indexPath.row] {
            cell.textLabel?.text = option.optionName.rawValue
        }
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .primaryWhite
        cell.textLabel?.font = Fonts.helveticaNeue16
        
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = selectedBackgroundView
        
        return cell
    }
}

extension ProgressViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 73
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let optionData = viewModel?.options[indexPath.row] {
            viewModel?.navigateToChart(optionData: optionData)
        }
    }
}
