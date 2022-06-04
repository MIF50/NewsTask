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
