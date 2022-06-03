//
//  NewsViewController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit

public protocol NewsImageDataLoaderTask {
    func cancel()
}

public protocol NewsImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> NewsImageDataLoaderTask
}

final public class NewsViewController: UITableViewController, UITableViewDataSourcePrefetching {
    
    
    
    private var newsLoader: NewsLoader?
    private var imageLoader: NewsImageDataLoader?
    private var tableModel = [NewsImage]()
    private var tasks = [IndexPath: NewsImageDataLoaderTask]()
    
    public convenience init(newsLoader: NewsLoader,imageLoader: NewsImageDataLoader) {
        self.init()
        self.newsLoader = newsLoader
        self.imageLoader = imageLoader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        tableView.prefetchDataSource = self
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        newsLoader?.load { [weak self] result in
            if let news = try? result.get() {
                self?.tableModel = news
                self?.tableView.reloadData()
            }
            self?.refreshControl?.endRefreshing()
        }
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = tableModel[indexPath.row]
        let cell = NewsImageCell()
        cell.titleLabel.text = cellModel.title
        cell.sourceLabel.text = cellModel.source
        cell.newsImageView.image = nil
        cell.newsImageRetryButton.isHidden = true
        cell.newsImageContainer.startShimmering()
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.tasks[indexPath] = self.imageLoader?.loadImageData(from: cellModel.url) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.newsImageView.image = image
                cell?.newsImageRetryButton.isHidden = (image != nil)
                cell?.newsImageContainer.stopShimmering()
            }
        }
        cell.onRetry = loadImage
        loadImage()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            let cellModel = tableModel[indexPath.row]
            tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url) { _ in }
        }
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelTask(forRowAt: indexPath)
    }
    
    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelTask)
    }
    
    private func cancelTask(forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
