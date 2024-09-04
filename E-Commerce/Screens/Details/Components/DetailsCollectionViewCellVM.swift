//
//  DetailsCollectionViewCellVM.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation

class DetailsCollectionViewCellVM {
    private let product: Product

    var productImageURL: URL {
        product.image
    }

    var productTitle: String {
        product.title
    }

    var productPrice: String {
        "$" + "\(product.price)"
    }

    init(product: Product) {
        self.product = product
    }
}
