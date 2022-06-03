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
        let presentationAdapter = NewsPresentationAdapter(newsLoader: newsLoader)
        let refreshController = NewsRefreshController(delegate: presentationAdapter)
        let newsController = NewsViewController(refreshController: refreshController)
        let newsViewAdapter = NewsViewAdapter(controller: newsController, imageLoader: imageLoader)
        presentationAdapter.presenter = NewsPresenter(
            newsView: newsViewAdapter,
            loadingView: WeakVirtualProxy(refreshController)
        )
        return newsController
    }
    
    private static func adaptNewsToCellController(
        forwardingTo controller: NewsViewController,
        loader: NewsImageDataLoader
    ) -> ([NewsImage]) -> Void {
        return { [weak controller] news in
            controller?.tableModel = news.map { model in
                NewsImageCellController(viewModel: NewsImageViewModel(
                    model: model,
                    imageLoader: loader,
                    imageTransformer: UIImage.init
                ))
            }
        }
    }
}

private final class WeakVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakVirtualProxy: NewsLoadingView where T: NewsLoadingView {
    func display(_ viewModel: NewsLoadingViewModel) {
        object?.display(viewModel)
    }
}

final class NewsViewAdapter: NewsView {
    private weak var controller:NewsViewController?
    private let imageLoader:NewsImageDataLoader
    
    init(controller: NewsViewController,imageLoader: NewsImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: NewsViewModel) {
        controller?.tableModel = viewModel.news.map { model in
            NewsImageCellController(viewModel: NewsImageViewModel(
                model: model,
                imageLoader: imageLoader,
                imageTransformer: UIImage.init
            ))
        }
    }
}

final class NewsPresentationAdapter: NewsRefreshViewControllerDelegate {
    private let newsLoader: NewsLoader
    var presenter: NewsPresenter?
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    func didRequestNewsRefresh() {
        presenter?.didStartLoadingNews()
        
        newsLoader.load { [weak self] result in
            switch result {
            case let .success(news):
                self?.presenter?.didFinishLoadingNews(with: news)
            case let .failure(error):
                self?.presenter?.didFinishLoadingNews(with: error)
            }
        }
    }
}
