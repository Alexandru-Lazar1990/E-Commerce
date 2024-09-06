//
//  DashboardViewModel.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation
import Combine

class DashboardViewModel {
    private let productService: ProductServiceProtocol
    private let localStorageService: LocalStorageServiceProtocol
    private var cancellables = Set<AnyCancellable>()

    let isLoading = CurrentValueSubject<Bool, Never>(true)
    let showCartScreen = PassthroughSubject<Void, Never>()
    let showDetailsScreen = PassthroughSubject<DetailsItem, Never>()
    let showError = PassthroughSubject<String, Never>()
    var products: [Product] = []

    var screenTitle: String {
        "Dashboard"
    }

    init(productService: ProductServiceProtocol,
         localStorageService: LocalStorageServiceProtocol) {
        self.productService = productService
        self.localStorageService = localStorageService
    }

    func getProducts() {
        Task { [weak self] in
            self?.isLoading.send(true)
            do {
                self?.products = try await self?.productService.getProducts() ?? []
            } catch let error {
                self?.showError.send(error.localizedDescription)
            }
            self?.isLoading.send(false)
        }
    }

    func getItemAt(index: Int) -> Product {
        products[index]
    }


    func openCartScreen() {
        showCartScreen.send()
    }

    func openDetailsScreenWithItemAt(_ index: Int) {
        let detailsItem = DetailsItem(product: products[index], suggestions: formSuggestions())
        showDetailsScreen.send(detailsItem)
    }

    private func formSuggestions() -> [Product] {
        Array(products.shuffled().prefix(5))
    }
}
