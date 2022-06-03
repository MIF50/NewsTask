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
    func loadImageData(from url: URL) -> NewsImageDataLoaderTask
}

final public class NewsViewController: UITableViewController {
    
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
        tasks[indexPath] = imageLoader?.loadImageData(from: cellModel.url)
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tasks[indexPath]?.cancel()
        tasks[indexPath] = nil
    }
}
