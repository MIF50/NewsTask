//
//  NewsImageViewModel.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

final class NewsImageViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private var task: NewsImageDataLoaderTask?
    private let model: NewsImage
    private let imageLoader: NewsImageDataLoader
    
    init(model: NewsImage,imageLoader: NewsImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    var title: String {
        model.title
    }
    
    var source: String {
        model.source
    }
    
    var onImageLoad: Observer<UIImage>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadingStateChange: Observer<Bool>?
    
    func LoadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadingStateChange?(false)
        task = imageLoader.loadImageData(from: model.url, completion: { [weak self] result in
            self?.handle(result)
        })
    }
    
    private func handle(_ result: NewsImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(UIImage.init) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadingStateChange?(true)
        }
        onImageLoadingStateChange?(false)
    }
    
    func cancelImageDataLoad() {
        task?.cancel()
        task = nil
    }
}
