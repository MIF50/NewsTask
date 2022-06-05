//
//  NewsPresentationAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation
import Combine

final class NewsPresentationAdapter: NewsRefreshViewControllerDelegate {
    private let newsLoader: () -> AnyPublisher<[NewsImage], Error>
    private var cancellable: Cancellable?

    var presenter: NewsPresenter?
    
    init(newsLoader:@escaping () -> AnyPublisher<[NewsImage], Error>) {
        self.newsLoader = newsLoader
    }
    
    func didRequestNewsRefresh() {
        presenter?.didStartLoadingNews()
        
        cancellable = newsLoader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        print(error)
                        self?.presenter?.didFinishLoadingNews(with: error)
                    }
                }, receiveValue: { [weak self] news in
                    self?.presenter?.didFinishLoadingNews(with: news)
                })
    }
}
