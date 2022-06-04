//
//  NewsUIComposer.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

public final class NewsUIComposer {
    
    private init() { }
    
    public static func composedWith(
        newsLoader: NewsLoader,
        imageLoader: NewsImageDataLoader
    ) -> NewsViewController {
        
        let presentationAdapter = NewsPresentationAdapter(
            newsLoader: MainQueueDispatchDecorator(decoratee: newsLoader)
        )
        let refreshController = NewsRefreshController(delegate: presentationAdapter)

        let newsController = NewsViewController.makeWith(
            refreshController: refreshController,
            title: NewsPresenter.title
        )

        let newsViewAdapter = NewsViewAdapter(controller: newsController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader))
        presentationAdapter.presenter = NewsPresenter(
            newsView: newsViewAdapter,
            loadingView: WeakRefVirtualProxy(refreshController)
        )
        return newsController
    }
}

private extension NewsViewController {
    static func makeWith(refreshController: NewsRefreshController, title: String) -> NewsViewController {
        let newsController = NewsViewController(refreshController: refreshController)
        newsController.title = NewsPresenter.title
        return newsController
    }
}

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
