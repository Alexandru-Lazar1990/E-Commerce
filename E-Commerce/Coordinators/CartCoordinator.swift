//
//  CartCoordinator.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import UIKit
import Combine

class CartCoordinator: BaseCoordinator {
    weak var parentCoordinator: BaseCoordinator?
    var children: [BaseCoordinator] = []
    weak var navigationController: UINavigationController!
    weak var appContext: AppContext!
    private var cancellables = Set<AnyCancellable>()

    private lazy var viewModel: CartViewModel = {
        return CartViewModel(localStorageService: appContext.localStorageService)
    }()

    init(navigationController: UINavigationController, appContext: AppContext) {
        self.navigationController = navigationController
        self.appContext = appContext
    }

    func start() {
        let cartViewController = CartViewController.instantiate()
        cartViewController.viewModel = viewModel
        cartViewController.dismiss
            .sink { [unowned self] in
                self.parentCoordinator?.childDidFinish(self)
            }
            .store(in: &cancellables)
        navigationController.pushViewController(cartViewController, animated: true)
    }
}
