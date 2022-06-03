//
//  NewsViewController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit

final public class NewsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    private var refreshController: NewsRefreshController?
    private var imageLoader: NewsImageDataLoader?
    private var tableModel = [NewsImage]() {
        didSet { tableView.reloadData() }
    }
    private var cellControllers = [IndexPath: NewsImageCellController]()
    
    public convenience init(newsLoader: NewsLoader,imageLoader: NewsImageDataLoader) {
        self.init()
        self.refreshController = NewsRefreshController(newsLoader: newsLoader)
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.prefetchDataSource = self
        refreshControl = refreshController?.view
        refreshController?.onRefresh = { [weak self] news in
            self?.tableModel = news
        }
        refreshController?.refresh()
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view()
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        removeCellController(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(removeCellController(forRowAt:))
    }
    
    
    private func cellController(forRowAt indexPath: IndexPath) -> NewsImageCellController {
            let cellModel = tableModel[indexPath.row]
            let cellController = NewsImageCellController(model: cellModel, imageLoader: imageLoader!)
            cellControllers[indexPath] = cellController
            return cellController
        }

        private func removeCellController(forRowAt indexPath: IndexPath) {
            cellControllers[indexPath] = nil
        }
}
