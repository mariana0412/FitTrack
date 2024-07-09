//
//  MusclesViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class MusclesViewController: BaseViewController {
    var viewModel: MusclesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> MusclesViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.muscles, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.musclesViewController) as! MusclesViewController
    }
    
}
