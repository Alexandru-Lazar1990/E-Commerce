//
//  CartViewController.swift
//  E-Commerce
//
//  Created by Alexandru Lazar on 03.09.2024.
//

import UIKit
import Combine

class CartViewController: DeinitableViewController {

    @IBOutlet private var tableView: UITableView!
    private var datasource: UITableViewDiffableDataSource<Int, Product>!
    private var cancellables = Set<AnyCancellable>()

    var viewModel: CartViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupDatasource()
        setupBindings()
    }

    private func setupUI() {
        title = viewModel.screenTitle
    }

    private func setupTableView() {
        DashboardCell.register(to: tableView)
        tableView.delegate = self
    }

    private func setupBindings() {
        viewModel.reloadData
            .sink { [unowned self] in
                self.updateDatasource()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Datasource
extension CartViewController {
    private func setupDatasource() {
        datasource = UITableViewDiffableDataSource<Int,
                                                   Product>(tableView: tableView,
                                                                      cellProvider: { [unowned self] tableView, indexPath, item in
                                                       return self.configureCellsOn(tableView, with: item, at: indexPath)
                                                   })
        updateDatasource()
    }

    func updateDatasource() {
        var initialSnapshot = NSDiffableDataSourceSnapshot<Int, Product>()
        initialSnapshot.appendSections([0])
        initialSnapshot.appendItems(viewModel.loadCartItems(), toSection: 0)
        datasource.apply(initialSnapshot, animatingDifferences: false)
    }

    private func configureCellsOn(_ tableView: UITableView, with item: Product, at indexPath: IndexPath) -> UITableViewCell {
        let cellID = DashboardCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? DashboardCell else {
            assertionFailure("could not dequeue DashboardCell")
            return UITableViewCell()
        }
        cell.viewModel = viewModel.formViewModelFrom(item: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, 
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] (_, _, completionHandler) in
            self?.viewModel.deleteItemAt(indexPath.row)
            completionHandler(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
