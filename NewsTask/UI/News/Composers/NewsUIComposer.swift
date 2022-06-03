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
        let viewModel = NewsViewModel(newsLoader: newsLoader)
        let refreshController = NewsRefreshController(viewModel: viewModel)
        let newsController = NewsViewController(refreshController: refreshController)
        viewModel.onLoadNews = adaptNewsToCellController(forwardingTo: newsController, loader: imageLoader)
        return newsController
    }
    
    private static func adaptNewsToCellController(
        forwardingTo controller: NewsViewController,
        loader: NewsImageDataLoader
    ) -> ([NewsImage]) -> Void {
        return { [weak controller] news in
            controller?.tableModel = news.map { model in
                NewsImageCellController(viewModel: NewsImageViewModel(model: model, imageLoader: loader))
            }
        }
    }
}
