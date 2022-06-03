//
//  NewsPresenter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

protocol NewsLoadingView {
    func display(isLoading: Bool)
}

protocol NewsView {
    func display(news: [NewsImage])
}

class NewsPresenter {
        
    private let newsLoader: NewsLoader
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    var newsView: NewsView?
    var loadingView: NewsLoadingView?
    
    func loadNews() {
        loadingView?.display(isLoading: true)
        newsLoader.load { [weak self] result in
            if let news = try? result.get() {
                self?.newsView?.display(news: news)
            }
            self?.loadingView?.display(isLoading: false)
        }
    }
}
