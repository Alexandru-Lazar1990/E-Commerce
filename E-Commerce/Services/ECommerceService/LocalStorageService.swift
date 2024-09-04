//
//  LocalStorageService.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import Foundation

protocol LocalStorageServiceProtocol {
    func saveCartItem(_ item: CartItem)
    func loadCartItems() -> [CartItem]
    func removeCartItem(_ item: CartItem)
}

class LocalStorageService: LocalStorageServiceProtocol {
    private let cartKey = "cartKey"

    func saveCartItem(_ item: CartItem) {
        var cartItems = loadCartItems()
        if let index = cartItems.firstIndex(where: { $0.product.id == item.product.id }) {
            cartItems[index].quantity += item.quantity
        } else {
            cartItems.append(item)
        }
        if let data = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(data, forKey: cartKey)
        }
    }

    func loadCartItems() -> [CartItem] {
        if let savedData = UserDefaults.standard.data(forKey: cartKey),
           let items = try? JSONDecoder().decode([CartItem].self, from: savedData) {
            return items
        }
        return []
    }

    func removeCartItem(_ item: CartItem) {
        var cartItems = loadCartItems()
        cartItems.removeAll { $0.product.id == item.product.id }
        if let data = try? JSONEncoder().encode(cartItems) {
            UserDefaults.standard.set(data, forKey: cartKey)
        }
    }
}
