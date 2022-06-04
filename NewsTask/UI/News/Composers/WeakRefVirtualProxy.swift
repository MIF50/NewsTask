//
//  WeakRefVirtualProxy.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import UIKit

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: NewsLoadingView where T: NewsLoadingView {
    func display(_ viewModel: NewsLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: NewsImageView where T: NewsImageView, T.Image == UIImage {
    func display(_ model: NewsImageViewModel<UIImage>) {
        object?.display(model)
    }
}
