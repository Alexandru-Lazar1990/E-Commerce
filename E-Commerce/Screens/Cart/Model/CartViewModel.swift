//
//  CartViewModel.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation
import Combine

class CartViewModel {
    private let localStorageService: LocalStorageServiceProtocol
    let reloadData = PassthroughSubject<Void, Never>()
    private var cartItems: [CartItem] = []
    var screenTitle: String {
        "Cart"
    }

    init(localStorageService: LocalStorageServiceProtocol) {
        self.localStorageService = localStorageService
    }

    func loadCartItems() -> [Product] {
        let cartItems = localStorageService.loadCartItems()
        self.cartItems = cartItems
        return cartItems.map { $0.product }
    }

    func deleteItemAt(_ index: Int) {
        localStorageService.removeCartItem(cartItems[index])
        reloadData.send()
    }

    func formViewModelFrom(item: Product) -> DashboardCellViewModel? {
        guard let cartItem = cartItems.first(where: { $0.product.id == item.id }) else {
            return nil
        }
        return DashboardCellViewModel(product: cartItem.product, quantity: cartItem.quantity)
    }
}
