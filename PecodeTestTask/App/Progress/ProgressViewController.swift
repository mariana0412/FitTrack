//
//  ProgressViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class ProgressViewController: BaseViewController {
    var viewModel: ProgressViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> ProgressViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.progress, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.progressViewController) as! ProgressViewController
    }
    
}
