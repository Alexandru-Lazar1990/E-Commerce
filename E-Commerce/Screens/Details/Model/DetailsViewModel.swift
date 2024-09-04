//
//  DetailsViewModel.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation
import Combine

struct DetailsItem {
    var product: Product
    var suggestions: [Product]
}

class DetailsViewModel {
    private let product: Product
    private let localStorageService: LocalStorageServiceProtocol
    var suggestions: [Product]
    let showDetailsScreen = PassthroughSubject<Product, Never>()

    var screenTitle: String {
        "Product Details"
    }

    var productDescription: String {
        product.description
    }

    var productImageURL: URL {
        product.image
    }

    var productPrice: String {
        "$" + "\(product.price)"
    }

    var productCategory: String {
        product.category
    }

    var productRating: String {
        "\(product.rating)"
    }

    var hasSuggestions: Bool {
        !suggestions.isEmpty
    }

    init(product: Product, suggestions: [Product] = [], localStorageService: LocalStorageServiceProtocol) {
        self.product = product
        self.suggestions = suggestions
        self.localStorageService = localStorageService
    }

    func openDetailsScreenWithItemAt(_ index: Int) {
        let suggestionItem = suggestions[index]
        showDetailsScreen.send(suggestionItem)
    }

    func addItemToCart() {
        let item = CartItem(product: product, quantity: 1)
        localStorageService.saveCartItem(item)
    }
}
