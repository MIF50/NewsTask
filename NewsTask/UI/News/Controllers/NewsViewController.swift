//
//  NewsViewController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit

public final class NewsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    private var refreshController: NewsRefreshController?
    private var loadingControllers = [IndexPath: NewsImageCellController]()
    private var tableModel = [NewsImageCellController]() {
        didSet { tableView.reloadData() }
    }
    
    convenience init(refreshController: NewsRefreshController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        refreshControl = refreshController?.view
        refreshController?.refresh()
    }
    
    private func configureTableView() {
        tableView.register(cell: NewsImageCell.self)
        tableView.rowHeight = 100
        tableView.prefetchDataSource = self
    }
    
    func display( _ items: [NewsImageCellController]) {
        loadingControllers = [:]
        tableModel = items
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad(forRowAt:))
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).selection()
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> NewsImageCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}
