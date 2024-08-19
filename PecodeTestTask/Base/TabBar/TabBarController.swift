//
//  TabBarController.swift
//  PecodeTestTask
//
//  Created by Mariana Piz on 08.07.2024.
//

import UIKit

class TabBarController: UITabBarController {

    @IBOutlet weak var customTabBar: CustomTabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarAppearance()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func configureTabBarAppearance() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.black
        
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.primaryYellow]
                
        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
}
