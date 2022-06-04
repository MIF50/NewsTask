//
//  NewsPresenter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

protocol NewsLoadingView {
    func display(_ viewModel: NewsLoadingViewModel)
}

protocol NewsView {
    func display(_ viewModel: NewsViewModel)
}

class NewsPresenter {
    private let newsView: NewsView
    private let loadingView: NewsLoadingView
    
    static var title: String {
        return NSLocalizedString("NEWS_VIEW_TITLE",
                                 tableName: "News",
                                 bundle: Bundle(for: NewsPresenter.self),
                                 comment: "Title for the news view")
    }
    
    init(newsView: NewsView,loadingView: NewsLoadingView) {
        self.newsView = newsView
        self.loadingView = loadingView
    }
    
    func didStartLoadingNews() {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didStartLoadingNews() }
        }
        loadingView.display(NewsLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingNews(with news: [NewsImage]) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingNews(with: news) }
        }
        newsView.display(NewsViewModel(news: news))
        loadingView.display(NewsLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingNews(with error: Error) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async { [weak self] in self?.didFinishLoadingNews(with: error) }
        }
       loadingView.display(NewsLoadingViewModel(isLoading: false))
    }
}
