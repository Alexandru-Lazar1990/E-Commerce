//
//  DetailsViewController.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit

class DetailsViewController: DeinitableViewController {

    @IBOutlet private var productImageView: UIImageView!
    @IBOutlet private var priceLabel: UILabel!
    @IBOutlet private var categoryLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var collectionView: UICollectionView!

    private var datasource: UICollectionViewDiffableDataSource<Int, Product>!

    var viewModel: DetailsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        setupDatasource()
    }

    private func setupCollectionView() {
        DetailsCollectionViewCell.register(to: collectionView)
        collectionView.delegate = self
        let section: NSCollectionLayoutSection = {
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7), heightDimension: .estimated(250))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        }()
        collectionView.setCollectionViewLayout(UICollectionViewCompositionalLayout(section: section), animated: true)
    }

    private func setupUI() {
        title = viewModel.screenTitle
        productImageView.loadImage(from: viewModel.productImageURL, placeholder: UIImage(named: "placeholder"))
        categoryLabel.text = viewModel.productCategory
        priceLabel.text = viewModel.productPrice
        descriptionLabel.text = viewModel.productDescription
        ratingLabel.text = viewModel.productRating
        let barItem = UIBarButtonItem(image: UIImage(named: "add"), style: .plain, target: self, action: #selector(addToCart))
        navigationItem.rightBarButtonItem = barItem
    }

    @objc private func addToCart() {
        viewModel.addItemToCart()
    }
}

// MARK: - Datasource
extension DetailsViewController {
    private func setupDatasource() {
        if !viewModel.hasSuggestions {
            collectionView.isHidden = true
            return
        }
        datasource = UICollectionViewDiffableDataSource<Int,
                                                   Product>(collectionView: collectionView,
                                                                      cellProvider: { [unowned self] tableView, indexPath, item in
                                                       return self.configureCellsOn(tableView, with: item, at: indexPath)
                                                   })
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, Product>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(viewModel.suggestions, toSection: 0)
        datasource.apply(initialSnapshot, animatingDifferences: false)
    }

    private func configureCellsOn(_ collectionView: UICollectionView, with item: Product, at indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = DetailsCollectionViewCell.identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? DetailsCollectionViewCell else {
            assertionFailure("could not dequeue DashboardCell")
            return UICollectionViewCell()
        }
        cell.viewModel = DetailsCollectionViewCellVM(product: item)
        return cell
    }
}

// MARK: - CollectionViewDelegate
extension DetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.openDetailsScreenWithItemAt(indexPath.row)
    }
}
