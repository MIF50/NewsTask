//
//  NewsUIComposer.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit
import Combine

public final class NewsUIComposer {
    
    private init() { }
    
    public static func composedWith(
        newsLoader: @escaping () -> AnyPublisher<[NewsImage], Error>,
        imageLoader: @escaping (URL) -> NewsImageDataLoader.Publisher,
        selection: @escaping (NewsImage) -> Void = { _ in }
    ) -> NewsViewController {
        
        let presentationAdapter = NewsPresentationAdapter(
            newsLoader: newsLoader
        )
        let refreshController = NewsRefreshController(delegate: presentationAdapter)
        
        let newsController = makeNewsViewController(
            refreshController: refreshController,
            title: NewsPresenter.title
        )
        
        let newsViewAdapter = NewsViewAdapter(controller: newsController, imageLoader: imageLoader,selection: selection)
        presentationAdapter.presenter = NewsPresenter(
            newsView: newsViewAdapter,
            loadingView: WeakRefVirtualProxy(refreshController)
        )
        return newsController
    }
    
    private static func makeNewsViewController(
        refreshController: NewsRefreshController,
        title: String
    ) -> NewsViewController {
        let newsController = NewsViewController(refreshController: refreshController)
        newsController.title = NewsPresenter.title
        return newsController
    }
}
