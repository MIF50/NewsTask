//
//  NewsViewController+LoaderSpy.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit
import NewsTask

class LoaderSpy: NewsLoader,NewsImageDataLoader {
    
    // MARK: - NewsLoader
    
    private var newsRequests = [(NewsLoader.Result) -> Void]()
    
    var loadNewsCallCount: Int {
        newsRequests.count
    }
    
    func load(completion: @escaping (NewsLoader.Result) -> Void) {
        newsRequests.append(completion)
    }
    
    func completeNewsLoading(with news:[NewsImage] = [],at index: Int) {
        newsRequests[index](.success(news))
    }
    
    func completeNewsLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        newsRequests[index](.failure(error))
    }
    
    // MARK: - NewsImageDataLoader
    
    private struct TaskSpy: NewsImageDataLoaderTask {
        let cancelCallback: () -> Void
        func cancel() {
            cancelCallback()
        }
    }
    
    private var imageRequests = [(url: URL, completion: (NewsImageDataLoader.Result) -> Void)]()
    private(set) var cancelledImageURLs = [URL]()
    
    var loadedImageURLs: [URL] {
        return imageRequests.map { $0.url }
    }
    
    func loadImageData(from url: URL, completion: @escaping (NewsImageDataLoader.Result) -> Void) -> NewsImageDataLoaderTask {
        imageRequests.append((url, completion))
        return TaskSpy { [weak self] in self?.cancelledImageURLs.append(url) }
    }
    
    func completeImageLoading(with imageData: Data = Data(), at index: Int = 0) {
        imageRequests[index].completion(.success(imageData))
    }
    
    func completeImageLoadingWithError(at index: Int = 0) {
        let error = NSError(domain: "an error", code: 0)
        imageRequests[index].completion(.failure(error))
    }
}
