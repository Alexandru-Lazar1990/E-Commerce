//
//  CartItem.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import Foundation

struct CartItem: Codable, Equatable {
    var product: Product
    var quantity: Int
}
