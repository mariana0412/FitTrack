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
            static let cellHeight: CGFloat = 171
        }
    }
    
    @IBOutlet weak var exercisesTableView: UITableView!
    
    var viewModel: MusclesViewModel?
    private var selectedCells: Set<IndexPath> = []
    private var selectedCellsNumbers: [Int: UILabel] = [:]
    private var resetButton: UIBarButtonItem?
    private let refreshControl = UIRefreshControl()
    private var expandedSections: Set<Int> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel?.loadExercises {}
        setupTableView()
        setupRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
        closeAllSections()
    }
    
    static func instantiate() -> MusclesViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.muscles, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.musclesViewController) as! MusclesViewController
    }
   
    private func setupTableView() {
        exercisesTableView.delegate = self
        exercisesTableView.dataSource = self
        
        let nib = UINib(nibName: ExerciseViewCell.reuseIdentifier, bundle: nil)
        exercisesTableView.register(nib, forCellReuseIdentifier: ExerciseViewCell.reuseIdentifier)
        exercisesTableView.register(ExercisesTableHeaderView.self, forHeaderFooterViewReuseIdentifier: ExercisesTableHeaderView.reuseIdentifier)
        
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
        closeAllSections() 
        refreshControl.endRefreshing()
    }
    
    private func numberOfSelectedCells(in section: Int) -> Int {
        selectedCells.filter { $0.section == section }.count
    }
    
    private func closeAllSections() {
        expandedSections.removeAll()
        exercisesTableView.reloadData()
    }
    
}

extension MusclesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.muscleGroups.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if expandedSections.contains(section) {
            return viewModel?.muscleGroups[section].exercisesList.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ExerciseViewCell.reuseIdentifier,
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
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ExercisesTableHeaderView.reuseIdentifier) as? ExercisesTableHeaderView else {
            return nil
        }
        
        let title = viewModel?.muscleGroups[section].muscleName ?? ""
        let count = numberOfSelectedCells(in: section)
        headerView.configure(with: title,
                             count: count,
                             isExpanded: expandedSections.contains(section))
        headerView.section = section
        headerView.delegate = self
        
        return headerView
    }
    
    private func updateHeaderCount(for section: Int) {
        if let headerView = exercisesTableView.headerView(forSection: section) as? ExercisesTableHeaderView {
            let selectedCount = numberOfSelectedCells(in: section)
            let sectionTitle = viewModel?.muscleGroups[section].muscleName ?? ""
            headerView.configure(with: sectionTitle,
                                 count: selectedCount,
                                 isExpanded: expandedSections.contains(section))
        }
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

extension MusclesViewController: ExercisesTableHeaderViewDelegate {
    func toggleSection(_ section: Int) {
        if expandedSections.contains(section) {
            expandedSections.remove(section)
        } else {
            expandedSections.insert(section)
        }
        exercisesTableView.reloadSections(IndexSet(integer: section), with: .automatic)
    }
}
