//
//  ApiServiceError.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import Foundation

enum APIServiceError: Error {
    case responseError
    case parseError(Error)
}
