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
        let refreshController = NewsRefreshController(newsLoader: newsLoader)
        let newsController = NewsViewController(refreshController: refreshController)
        refreshController.onRefresh = adaptNewsToCellController(forwardingTo: newsController, loader: imageLoader)
        return newsController
    }
    
    private static func adaptNewsToCellController(
        forwardingTo controller: NewsViewController,
        loader: NewsImageDataLoader
    ) -> ([NewsImage]) -> Void {
        return { [weak controller] news in
            controller?.tableModel = news.map {
                NewsImageCellController(model: $0, imageLoader: loader)
            }
        }
    }
}
