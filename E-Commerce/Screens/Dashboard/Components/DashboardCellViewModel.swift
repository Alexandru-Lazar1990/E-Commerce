//
//  DashboardCellViewModel.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation

class DashboardCellViewModel {
    private let product: Product
    private let quantity: Int

    var title: String {
        product.title
    }

    var imageURL: URL {
        product.image
    }

    var hasQuantity: Bool {
        quantity != 0
    }

    var productQuantity: String {
        "No. Of items: \(quantity)"
    }

    var category: String {
        product.category
    }

    var price: String {
        "$" + "\(product.price)"
    }

    init(product: Product, quantity: Int = 0) {
        self.product = product
        self.quantity = quantity
    }
}
