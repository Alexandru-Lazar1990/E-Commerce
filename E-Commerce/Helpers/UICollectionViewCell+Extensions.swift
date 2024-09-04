//
//  UICollectionViewCell+Extensions.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self)
    }

    static func register(to collectionView: UICollectionView) {
        let nibFile = UINib(nibName: identifier, bundle: nil)
        collectionView.register(nibFile, forCellWithReuseIdentifier: identifier)
    }

    static func registerClass(to collectionView: UICollectionView) {
        collectionView.register(self, forCellWithReuseIdentifier: identifier)
    }
}
