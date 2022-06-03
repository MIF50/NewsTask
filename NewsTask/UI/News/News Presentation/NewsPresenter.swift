//
//  NewsPresenter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

struct NewsLoadingViewModel {
    let isLoading: Bool
}

protocol NewsLoadingView {
    func display(_ viewModel: NewsLoadingViewModel)
}

struct NewsViewModel {
    let news: [NewsImage]
}

protocol NewsView {
    func display(_ viewModel: NewsViewModel)
}

class NewsPresenter {
        
    private let newsLoader: NewsLoader
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    var newsView: NewsView?
    var loadingView: NewsLoadingView?
    
    func loadNews() {
        loadingView?.display(NewsLoadingViewModel(isLoading: true))
        newsLoader.load { [weak self] result in
            if let news = try? result.get() {
                self?.newsView?.display(NewsViewModel(news: news))
            }
            self?.loadingView?.display(NewsLoadingViewModel(isLoading: false))
        }
    }
}
