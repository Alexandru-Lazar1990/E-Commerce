//
//  UITableViewCell+Extensions.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    static func register(to tableView: UITableView) {
        let nibFile = UINib(nibName: identifier, bundle: nil)
        tableView.register(nibFile, forCellReuseIdentifier: identifier)
    }
}
