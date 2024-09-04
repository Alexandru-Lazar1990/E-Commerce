//
//  BaseCoordinator.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import UIKit

protocol BaseCoordinator: AnyObject {
    var parentCoordinator: BaseCoordinator? { get set }
    var navigationController: UINavigationController! { get set }
    var children: [BaseCoordinator] { get set }
    var appContext: AppContext! { get set }

    func start()
}

extension BaseCoordinator {
    func childDidFinish(_ coordinator : BaseCoordinator) {
        for (index, child) in children.enumerated() {
            if child === coordinator {
                children.remove(at: index)
                break
            }
        }
    }
}
