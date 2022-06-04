//
//  NewsPresentationAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation

final class NewsPresentationAdapter: NewsRefreshViewControllerDelegate {
    private let newsLoader: NewsLoader
    var presenter: NewsPresenter?
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    func didRequestNewsRefresh() {
        presenter?.didStartLoadingNews()
        
        newsLoader.load { [weak self] result in
            switch result {
            case let .success(news):
                self?.presenter?.didFinishLoadingNews(with: news)
            case let .failure(error):
                self?.presenter?.didFinishLoadingNews(with: error)
            }
        }
    }
}
