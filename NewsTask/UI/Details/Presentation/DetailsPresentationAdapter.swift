//
//  DetailsPresentationAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 05/06/2022.
//

import Combine

final class DetailsPresentationAdapter: DetailsImageLoader {
    private let loader: () -> NewsImageDataLoader.Publisher
    private var cancellable: Cancellable?

    var presenter: DetailsPresenter?
    
    init(loader: @escaping () -> NewsImageDataLoader.Publisher) {
        self.loader = loader
    }
    
    func loadImage() {
        presenter?.didStartLoadingNews()
        
        cancellable = loader()
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingNews(with: error)
                    }
                }, receiveValue: { [weak self] news in
                    self?.presenter?.didFinishLoadingNews(with: news)
                })
    }
}
