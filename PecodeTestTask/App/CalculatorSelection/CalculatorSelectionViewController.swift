//
//  CalculatorViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

final class CalculatorSelectionViewController: BaseViewController {
    
    private enum Constants {
        enum TableView {
            static let cellReuseIdentifier = "CalculatorNameViewCell"
            static let rowHeight: CGFloat = 57
        }
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    var viewModel: CalculatorSelectionViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar()
    }
    
    static func instantiate() -> CalculatorSelectionViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.calculatorSelection, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.calculatorSelectionViewController) as! CalculatorSelectionViewController
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ListItemViewCell.self,
                                  forCellReuseIdentifier: Constants.TableView.cellReuseIdentifier)
    }
    
    private func configureNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        let _ = NavigationBarConfigurator.configureNavigationBar(
            for: self,
            title: viewModel?.navigationItemTitle ?? ""
        )
    }
    
}

extension CalculatorSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.calculatorTypesNames.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.TableView.cellReuseIdentifier,
                                                 for: indexPath) as! ListItemViewCell
        if let calculatorTypeName = viewModel?.calculatorTypesNames[indexPath.row] {
            cell.configure(with: calculatorTypeName)
        }
        
        return cell
    }
}

extension CalculatorSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.TableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
