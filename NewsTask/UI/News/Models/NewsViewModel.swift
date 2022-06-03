//
//  NewsViewModel.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

class NewsViewModel {
    
    typealias Observer<T> = (T) -> Void
    
    private let newsLoader: NewsLoader
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onLoadNews: Observer<[NewsImage]>?
    
    func loadNews() {
        onLoadingStateChange?(true)
        newsLoader.load { [weak self] result in
            if let news = try? result.get() {
                self?.onLoadNews?(news)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
