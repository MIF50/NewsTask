//
//  NewsViewAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import UIKit

final class NewsViewAdapter: NewsView {
    private weak var controller: NewsViewController?
    private let imageLoader: NewsImageDataLoader
    
    init(controller: NewsViewController,imageLoader: NewsImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ viewModel: NewsViewModel) {
        controller?.tableModel = viewModel.news.map { model in
            let adapter = NewsImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<NewsImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = NewsImageCellController(delegate: adapter)
            
            adapter.presenter = NewsImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init
            )
            
            return view
        }
    }
}
