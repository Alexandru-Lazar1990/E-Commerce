//
//  DashboardCell.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit

class DashboardCell: UITableViewCell {
    @IBOutlet private var productImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var quantityLabel: UILabel!

    var viewModel: DashboardCellViewModel! {
        didSet {
            productImageView.loadImage(from: viewModel.imageURL, placeholder: UIImage(named: "placeholder"))
            titleLabel.text = viewModel.title
            priceLabel.text = viewModel.price
            categoryLabel.text = viewModel.category
            quantityLabel.isHidden = !viewModel.hasQuantity
            quantityLabel.text = viewModel.productQuantity
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        productImageView.image = nil
        titleLabel.text = nil
        priceLabel.text = nil
        categoryLabel.text = nil
        quantityLabel.isHidden = false
    }
}
