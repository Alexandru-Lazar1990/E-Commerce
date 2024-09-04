//
//  DashboardCoordinator.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import UIKit
import Combine

class DashboardCoordinator: BaseCoordinator {
    weak var parentCoordinator: BaseCoordinator?
    var children: [BaseCoordinator] = []
    var navigationController: UINavigationController!
    var appContext: AppContext!
    private var cancellables = Set<AnyCancellable>()

    private lazy var viewModel: DashboardViewModel = {
        return DashboardViewModel(productService: appContext.productService,
                                  localStorageService: appContext.localStorageService)
    }()

    init(navigationController: UINavigationController, appContext: AppContext) {
        self.navigationController = navigationController
        self.appContext = appContext
    }

    func start() {
        let dashboardViewController = DashboardViewController.instantiate()
        dashboardViewController.viewModel = viewModel
        dashboardViewController.dismiss
            .sink { [unowned self] in
                self.parentCoordinator?.childDidFinish(self)
            }
            .store(in: &cancellables)
        navigationController?.pushViewController(dashboardViewController, animated: false)
        setupBindings()
    }

    private func setupBindings() {
        viewModel.showCartScreen
            .sink { [unowned self] in
                self.navigateToCartScreen()
            }
            .store(in: &cancellables)
        viewModel.showDetailsScreen
            .sink { [unowned self] detailsItem in
                self.navigateToDetailsScreenWith(detailsItem)
            }
            .store(in: &cancellables)
    }

    private func navigateToCartScreen() {
        let cartCoordinator = CartCoordinator(navigationController: navigationController, appContext: appContext)
        cartCoordinator.parentCoordinator = self
        children.append(cartCoordinator)
        cartCoordinator.start()
    }

    private func navigateToDetailsScreenWith(_ detailsItem: DetailsItem) {
        let detailsCoordinator = DetailsCoordinator(navigationController: navigationController,
                                                    appContext: appContext,
                                                    product: detailsItem.product,
                                                    suggestions: detailsItem.suggestions)
        detailsCoordinator.parentCoordinator = self
        children.append(detailsCoordinator)
        detailsCoordinator.start()
    }
}
