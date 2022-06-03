//
//  NewsRefreshController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

final class NewsRefreshController: NSObject {
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    private let newsLoader: NewsLoader
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    var onRefresh: (([NewsImage]) -> Void)?
    
    @objc func refresh() {
        view.beginRefreshing()
        newsLoader.load { [weak self] result in
            if let news = try? result.get() {
                self?.onRefresh?(news)
            }
            self?.view.endRefreshing()
        }
    }
}
