//
//  DetailsCoordinator.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import UIKit
import Combine

class DetailsCoordinator: BaseCoordinator {
    weak var parentCoordinator: BaseCoordinator?
    internal var children: [BaseCoordinator] = []
    internal weak var navigationController: UINavigationController!
    internal weak var appContext: AppContext!
    private var product: Product
    private var suggestions: [Product]
    private var cancellables = Set<AnyCancellable>()

    private lazy var viewModel: DetailsViewModel = {
        return DetailsViewModel(product: product,
                                suggestions: suggestions,
                                localStorageService: appContext.localStorageService)
    }()

    init(navigationController: UINavigationController,
         appContext: AppContext,
         product: Product,
         suggestions: [Product]) {
        self.navigationController = navigationController
        self.appContext = appContext
        self.product = product
        self.suggestions = suggestions
    }

    func start() {
        let detailsViewController = DetailsViewController.instantiate()
        detailsViewController.viewModel = viewModel
        detailsViewController.dismiss
            .sink { [unowned self] in
                self.parentCoordinator?.childDidFinish(self)
            }
            .store(in: &cancellables)
        navigationController.pushViewController(detailsViewController, animated: true)
        setupBindings()
    }

    private func setupBindings() {
        viewModel.showDetailsScreen
            .sink { [unowned self] product in
                self.navigateToDetailsScreenWith(product)
            }
            .store(in: &cancellables)
    }

    private func navigateToDetailsScreenWith(_ product: Product) {
        let moreDetailsCoordinator = DetailsCoordinator(navigationController: navigationController,
                                                        appContext: appContext,
                                                        product: product,
                                                        suggestions: [])
        moreDetailsCoordinator.parentCoordinator = parentCoordinator
        children.append(moreDetailsCoordinator)
        moreDetailsCoordinator.start()
    }
}
