//
//  NewsViewAdapter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import UIKit
import Combine

final class NewsViewAdapter: NewsView {
    private weak var controller: NewsViewController?
    private let imageLoader: (URL) -> NewsImageDataLoader.Publisher
    private let selection: (NewsImage) -> Void

    
    init(controller: NewsViewController,
         imageLoader: @escaping (URL) -> NewsImageDataLoader.Publisher,
         selection: @escaping (NewsImage) -> Void) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: NewsViewModel) {
        controller?.display(
            viewModel.news.map { model in
                let adapter = NewsImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<NewsImageCellController>, UIImage>(model: model, imageLoader: imageLoader)
                let view = NewsImageCellController(delegate: adapter,
                                                   selection: { [selection] in
                    selection(model)
                })
                
                adapter.presenter = NewsImagePresenter(
                    view: WeakRefVirtualProxy(view),
                    imageTransformer: UIImage.init
                )
                
                return view
            }
        )
    }
}
