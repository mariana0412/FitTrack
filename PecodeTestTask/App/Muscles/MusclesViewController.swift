//
//  MusclesViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

final class MusclesViewController: BaseViewController {
    
    private enum Constants {
        enum TableView {
            static let cellReuseIdentifier = "ExerciseViewCell"
            static let cellHeight: CGFloat = 171
            static let underlineHeight: CGFloat = 1
            static let underlineTop: CGFloat = 12
            static let headerViewBottom: CGFloat = 16
        }
    }
    
    @IBOutlet weak var exercisesTableView: UITableView!
    
    var viewModel: MusclesViewModel?
    var selectedCells: Set<IndexPath> = []
    private var selectedCellsNumbers: [Int: UILabel] = [:]
    private var resetButton: UIBarButtonItem?
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadExercises {}
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> MusclesViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.muscles, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.musclesViewController) as! MusclesViewController
    }
   
    private func setupTableView() {
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        
        let nib = UINib(nibName: Constants.TableView.cellReuseIdentifier, bundle: nil)
        exercisesTableView.register(nib, forCellReuseIdentifier: Constants.TableView.cellReuseIdentifier)
        
        exercisesTableView.refreshControl = refreshControl
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let (_, rightButton) = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationBarTitle ?? "",
            rightButtonName: viewModel?.navigationBarRightButtonTitle,
            rightButtonAction: #selector(resetButtonTapped)
        )
        self.resetButton = rightButton
        updateResetButtonVisibility()
    }
    
    @objc private func resetButtonTapped() {
        selectedCells.removeAll()
        exercisesTableView.reloadData()
        updateResetButtonVisibility()
    }
    
    private func updateResetButtonVisibility() {
        resetButton?.customView?.isHidden = selectedCells.isEmpty
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(handlePullToRefresh), for: .valueChanged)
        refreshControl.tintColor = .primaryYellow
    }
    
    @objc private func handlePullToRefresh() {
        selectedCells.removeAll()
        exercisesTableView.reloadData()
        updateResetButtonVisibility()
        refreshControl.endRefreshing()
    }
    
    private func numberOfSelectedCells(in section: Int) -> Int {
        selectedCells.filter { $0.section == section }.count
    }
    
    private func updateHeaderCount(for section: Int) {
        let selectedCount = numberOfSelectedCells(in: section)
        if let countLabel = selectedCellsNumbers[section] {
            countLabel.text = selectedCount > 0 ? "\(selectedCount)" : nil
        }
    }
    
}

extension MusclesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.muscleGroups.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.muscleGroups[section].exercisesList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.cellReuseIdentifier, 
                                                       for: indexPath) as? ExerciseViewCell else {
            return UITableViewCell()
        }
        
        if let exercise = viewModel?.muscleGroups[indexPath.section].exercisesList[indexPath.row] {
            let moreAboutButtonTitle = viewModel?.moreAboutButtonTitle ?? ""
            cell.configure(with: exercise, 
                           buttonText: moreAboutButtonTitle,
                           isSelected: selectedCells.contains(indexPath))
        }
        
        cell.delegate = self
        
        return cell
    }
}

extension MusclesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.TableView.cellHeight
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear

        let label = UILabel()
        label.text = viewModel?.muscleGroups[section].muscleName
        label.textColor = .primaryWhite
        label.font = Fonts.helveticaNeue18
        label.translatesAutoresizingMaskIntoConstraints = false

        let countLabel = UILabel()
        let selectedCount = numberOfSelectedCells(in: section)
        countLabel.text = selectedCount > 0 ? "\(selectedCount)" : nil
        countLabel.textColor = .primaryWhite
        countLabel.font = Fonts.helveticaNeue18
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        selectedCellsNumbers[section] = countLabel

        let underlineView = UIView()
        underlineView.backgroundColor = .primaryWhite
        underlineView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(label)
        headerView.addSubview(countLabel)
        headerView.addSubview(underlineView)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 24),
            
            countLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            countLabel.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            
            underlineView.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            underlineView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constants.TableView.underlineTop),
            underlineView.heightAnchor.constraint(equalToConstant: Constants.TableView.underlineHeight),
            headerView.bottomAnchor.constraint(equalTo: underlineView.bottomAnchor, constant: Constants.TableView.headerViewBottom)
        ])
        
        return headerView
    }
    
}

extension MusclesViewController: ExerciseViewCellDelegate {
    func didTapCell(_ cell: ExerciseViewCell) {
        guard let indexPath = exercisesTableView.indexPath(for: cell) else { return }
        
        if selectedCells.contains(indexPath) {
            selectedCells.remove(indexPath)
        } else {
            selectedCells.insert(indexPath)
        }
        
        exercisesTableView.reloadRows(at: [indexPath], with: .automatic)
        updateResetButtonVisibility()
        updateHeaderCount(for: indexPath.section)
    }
}
