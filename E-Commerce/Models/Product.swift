//
//  Product.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation

struct Product: Codable, Hashable, Equatable {
    var id: Int
    var title: String
    var price: Double
    var description: String
    var category: String
    var image: URL
    var rating: Rating

    struct Rating: Codable {
        var rate: Double
        var count: Int

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(rate, forKey: .rate)
            try container.encode(count, forKey: .count)
        }
    }

    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Product {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(price, forKey: .price)
        try container.encode(description, forKey: .description)
        try container.encode(category, forKey: .category)
        try container.encode(image, forKey: .image)
        try container.encode(rating, forKey: .rating)
    }
}
