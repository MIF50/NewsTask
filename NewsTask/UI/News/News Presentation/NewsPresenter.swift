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
    var newsView: NewsView?
    var loadingView: NewsLoadingView?
    
    func didStartLoadingNews() {
        loadingView?.display(NewsLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingNews(with news: [NewsImage]) {
        newsView?.display(NewsViewModel(news: news))
        loadingView?.display(NewsLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingNews(with error: Error) {
       loadingView?.display(NewsLoadingViewModel(isLoading: false))
    }
}