//
//  NewsImageDataLoaderPresentationAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation
import Combine

final class NewsImageDataLoaderPresentationAdapter<View: NewsImageView, Image>: NewsImageCellControllerDelegate where View.Image == Image {
    private let model: NewsImage
    private let imageLoader: (URL) -> NewsImageDataLoader.Publisher
    private var cancellable: Cancellable?

    private var task: NewsImageDataLoaderTask?
    
    var presenter: NewsImagePresenter<View, Image>?
    
    init(model: NewsImage, imageLoader: @escaping (URL) -> NewsImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        
        cancellable = imageLoader(model.url)
            .dispatchOnMainQueue()
            .sink(
                receiveCompletion: { [weak self] completion in
                    switch completion {
                    case .finished: break

                    case let .failure(error):
                        self?.presenter?.didFinishLoadingImageData(with: error, for: model)

                    }
                }, receiveValue: { [weak self] data in
                    self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                })
        
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
        cancellable = nil
    }
}
