//
//  ProductsService.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation

protocol ProductServiceProtocol {
    var apiSession: APIServiceProtocol { get }
    func getProducts() async throws -> [Product]
}

class ProductService: ProductServiceProtocol {
    var apiSession: APIServiceProtocol

    init(apiSession: APISession) {
        self.apiSession = apiSession
    }

    func getProducts() async throws -> [Product] {
       return try await apiSession.request(with: Endpoint.getProducts)
    }
}
