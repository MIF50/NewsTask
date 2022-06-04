//
//  NewsImagePresenter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

protocol NewsImageView {
    associatedtype Image
    
    func display(_ viewModel: NewsImageViewModel<Image>)
}

class NewsImagePresenter <View: NewsImageView, Image> where View.Image == Image {
    
    private let view: View
    private let imageTransformer: (Data) -> Image?
    
    internal init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }
    
    func didStartLoadingImageData(for model: NewsImage) {
        view.display(NewsImageViewModel(
            title: model.title,
            source: model.source,
            image: nil,
            timeAgo: model.date.timeAgoDisplay(),
            isLoading: true,
            shouldRetry: false))
    }
    
    private struct InvalidImageDataError: Error {}
    
    func didFinishLoadingImageData(with data: Data, for model: NewsImage) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        view.display(NewsImageViewModel(
            title: model.title,
            source: model.source,
            image: image,
            timeAgo: model.date.timeAgoDisplay(),
            isLoading: false,
            shouldRetry: false))
    }
    
    func didFinishLoadingImageData(with error: Error, for model: NewsImage) {
        view.display(NewsImageViewModel(
            title: model.title,
            source: model.source,
            image: nil,
            timeAgo: model.date.timeAgoDisplay(),
            isLoading: false,
            shouldRetry: true))
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
