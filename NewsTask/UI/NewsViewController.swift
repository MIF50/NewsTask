//
//  NewsViewController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit

final public class NewsViewController: UITableViewController {
    
    private var loader: NewsLoader?
    
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
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
}
