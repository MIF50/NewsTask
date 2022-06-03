//
//  NewsImageViewModel.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

final class NewsImageViewModel<Image> {
    
    typealias Observer<T> = (T) -> Void
    
    private var task: NewsImageDataLoaderTask?
    private let model: NewsImage
    private let imageLoader: NewsImageDataLoader
    private let imageTransformer: (Data) -> Image?
    
    init(model: NewsImage,imageLoader: NewsImageDataLoader,imageTransformer: @escaping ((Data) -> Image?)) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }
    
    var title: String {
        model.title
    }
    
    var source: String {
        model.source
    }
    
    var onImageLoad: Observer<Image>?
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
        if let image = (try? result.get()).flatMap(imageTransformer) {
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
