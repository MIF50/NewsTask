//
//  NewsImageDataLoaderPresentationAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation

final class NewsImageDataLoaderPresentationAdapter<View: NewsImageView, Image>: NewsImageCellControllerDelegate where View.Image == Image {
    private let model: NewsImage
    private let imageLoader: NewsImageDataLoader
    private var task: NewsImageDataLoaderTask?
    
    var presenter: NewsImagePresenter<View, Image>?
    
    init(model: NewsImage, imageLoader: NewsImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}
