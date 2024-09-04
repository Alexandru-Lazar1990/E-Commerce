//
//  ApiService.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation
import Combine

protocol RequestBuilder {
    var urlRequest: URLRequest { get }
}

protocol APIServiceProtocol {
    func request<T: Decodable>(with builder: RequestBuilder) async throws -> T
}

struct APISession: APIServiceProtocol {
    func request<T: Decodable>(with builder: RequestBuilder) async throws -> T {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)

        let (data, response) = try await URLSession.shared.data(for: builder.urlRequest)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.httpError(httpResponse.statusCode)
        }

        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return decodedObject
        } catch {
            throw APIError.decodingError
        }
    }
}

enum APIError: Error {
    case decodingError
    case httpError(Int)
    case unknown
}

enum Endpoint {
    case getProducts
//    case getCart(Int)
//    case addToCart(Product)
//    case updateCartItems(Int, [Product])
}

enum HttpMethod: String {
//    case post = "POST"
    case get = "GET"
//    case put = "PUT"
}

extension Endpoint: RequestBuilder {
    var urlRequest: URLRequest {
        switch self {
        case .getProducts:
            return formRequest(from: "https://fakestoreapi.com/products",
                               httpMethod: HttpMethod.get.rawValue)
//        case .getCart(let id):
//            return formRequest(from: "https://fakestoreapi.com/carts" + "/\(id)",
//                               httpMethod: HttpMethod.get.rawValue)
//        case .addToCart(let product):
//            return formRequest(from: "https://fakestoreapi.com/carts",
//                               httpMethod: HttpMethod.post.rawValue,
//                               httpBody: ["userId": 1,
//                                          "date": Date(),
//                                          "products": ["productId": product.id,
//                                                       "quantity": 1]])
//        case .updateCartItems(let id, let products):
//            var httpBody = ["userId" : 1,
//                            "date": Date()] as [String : Any]
//            let httpBodyProducts = products.reduce(into: [String: Int]()) { result, property in
//                result["productId"] = property.id
//                result["quantity"] = 1
//            }
//            httpBody["products"] = httpBodyProducts
//            return formRequest(from: "https://fakestoreapi.com/carts" + "/\(id)",
//                               httpMethod: HttpMethod.put.rawValue,
//                               httpBody: httpBody)
        }
    }

    private func formRequest(from url: String, httpMethod: String, httpBody: [String: Any] = [:]) -> URLRequest {
        guard let url = URL(string: url) else {
            preconditionFailure("Invalid URL format")
        }

        let requestBody = try? JSONSerialization.data(withJSONObject: httpBody)
        var request = URLRequest(url: url)
        if !httpBody.isEmpty {
            request.httpBody = requestBody
        }
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return request
    }
}
