//
//  DetailsCollectionViewCell.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit

class DetailsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!

    var viewModel: DetailsCollectionViewCellVM! {
        didSet {
            productImageView.loadImage(from: viewModel.productImageURL)
            titleLabel.text = viewModel.productTitle
            priceLabel.text = viewModel.productPrice
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
    }
}
