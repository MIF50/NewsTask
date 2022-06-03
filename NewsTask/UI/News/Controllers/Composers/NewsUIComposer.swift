//
//  NewsUIComposer.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

public final class NewsUIComposer {
    
    public static func composedWith(
        newsLoader: NewsLoader,
        imageLoader: NewsImageDataLoader
    ) -> NewsViewController {
        let refreshController = NewsRefreshController(newsLoader: newsLoader)
        let newsController = NewsViewController(refreshController: refreshController)
        refreshController.onRefresh = { [weak newsController] news in
            newsController?.tableModel = news.map {
                NewsImageCellController(model: $0, imageLoader: imageLoader)
            }
        }
        return newsController
    }
}
