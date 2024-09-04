//
//  Cart.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation

struct Cart: Decodable, Hashable {
    var id: Int
    var userId: Int
    var date: String
    var products: [CartProducts]

    struct CartProducts: Decodable {
        var productId: Int
        var quantity: Int
    }

    static func == (lhs: Cart, rhs: Cart) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
