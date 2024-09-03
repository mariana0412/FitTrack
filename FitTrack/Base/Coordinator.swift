//
//  Coordinator.swift
//  FitTrack
//
//  Created by Mariana Piz on 30.06.2024.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get }
    func start()
}
