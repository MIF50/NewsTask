//
//  NewsViewController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit

final public class NewsViewController: UITableViewController {
    
    private var loader: NewsLoader?
    private var tableModel = [NewsImage]()
    
    public convenience init(loader: NewsLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] result in
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
        return cell
    }
}
