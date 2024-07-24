//
//  OptionsViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 24.07.2024.
//

import UIKit

final class OptionsViewController: BaseViewController {
    
    @IBOutlet weak var addOptionsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var selectButton: CustomButton!
    
    var viewModel: OptionsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> OptionsViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.options, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.optionsViewController) as! OptionsViewController
    }
    
}
