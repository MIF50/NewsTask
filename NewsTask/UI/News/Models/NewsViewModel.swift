//
//  NewsViewModel.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

class NewsViewModel {
    
    private let newsLoader: NewsLoader
    
    init(newsLoader: NewsLoader) {
        self.newsLoader = newsLoader
    }
    
    var onChange: ((NewsViewModel) -> Void)?
    var onLoadNews: (([NewsImage]) -> Void)?
    
    private(set) var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    func loadNews() {
        isLoading = true
        newsLoader.load { [weak self] result in
            if let news = try? result.get() {
                self?.onLoadNews?(news)
            }
            self?.isLoading = false
        }
    }
}
