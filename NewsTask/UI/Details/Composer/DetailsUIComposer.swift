//
//  DetailsUIComposer.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 05/06/2022.
//

import UIKit
import Combine

class DetailsUIComposer {
    
    private init() { }
    
    public static func composedWith(
        imageLoader: @escaping () -> NewsImageDataLoader.Publisher,
        news: NewsImage
    ) -> NewsDetailsViewController {
        
        let presentationAdapter = DetailsPresentationAdapter(loader: imageLoader)
        
        
        let controller = makeDetailsViewController(loader: presentationAdapter,news: news)
        
        
        presentationAdapter.presenter = DetailsPresenter(detailsView: controller,
                                                         loadingView: WeakRefVirtualProxy(controller))
        
        return controller
    }
    
    private static func makeDetailsViewController(
        loader: DetailsImageLoader,
        news: NewsImage
    ) -> NewsDetailsViewController {
        let controller = NewsDetailsViewController(loader: loader,news: news)
        return controller
    }
    
}
