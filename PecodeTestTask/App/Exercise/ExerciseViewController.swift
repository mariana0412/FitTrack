//
//  ExerciseViewController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 12.08.2024.
//

import UIKit

final class ExerciseViewController: BaseViewController {
    var viewModel: ExerciseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static func instantiate() -> ExerciseViewController {
        let storyboard = UIStoryboard(name: StoryboardConstants.exercise, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: ViewControllerIdentifiers.exerciseViewController) as! ExerciseViewController
    }
    
}
