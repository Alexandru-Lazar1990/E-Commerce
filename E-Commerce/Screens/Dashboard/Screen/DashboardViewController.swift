//
//  DashboardViewController.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit
import Combine

class DashboardViewController: DeinitableViewController {

    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var tableView: UITableView!

    var viewModel: DashboardViewModel!
    private var datasource: UITableViewDiffableDataSource<Int, Product>!
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupBindings()
        viewModel.getProducts()
    }

    private func setupUI() {
        title = viewModel.screenTitle
        let barItem = UIBarButtonItem(image: UIImage(named: "cart"), style: .plain, target: self, action: #selector(openCartScreen))
        navigationItem.rightBarButtonItem = barItem
    }

    @objc private func openCartScreen() {
        viewModel.openCartScreen()
    }

    private func setupTableView() {
        DashboardCell.register(to: tableView)
        tableView.delegate = self
    }

    private func setupBindings() {
        viewModel.isLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.setupDatasource()
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                }
            }.store(in: &cancellables)
    }
}

// MARK: - Datasource
extension DashboardViewController {
    private func setupDatasource() {
        datasource = UITableViewDiffableDataSource<Int,
                                                   Product>(tableView: tableView,
                                                                      cellProvider: { [unowned self] tableView, indexPath, item in
                                                       return self.configureCellsOn(tableView, with: item, at: indexPath)
                                                   })
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, Product>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(viewModel.products, toSection: 0)
        datasource.apply(initialSnapshot, animatingDifferences: false)
    }

    private func configureCellsOn(_ tableView: UITableView, with item: Product, at indexPath: IndexPath) -> UITableViewCell {
        let cellID = DashboardCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DashboardCell else {
            assertionFailure("could not dequeue DashboardCell")
            return UITableViewCell()
        }
        cell.viewModel = DashboardCellViewModel(product: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openDetailsScreenWithItemAt(indexPath.row)
    }
}
