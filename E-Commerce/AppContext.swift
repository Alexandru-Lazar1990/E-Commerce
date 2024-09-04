//
//  AppContext.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 04.09.2024.
//

import Foundation

class AppContext {
    lazy var apiSession: APISession = { APISession() } ()
    lazy var productService: ProductServiceProtocol = { ProductService(apiSession: apiSession ) }()
    lazy var localStorageService: LocalStorageServiceProtocol = { LocalStorageService() }()
}
