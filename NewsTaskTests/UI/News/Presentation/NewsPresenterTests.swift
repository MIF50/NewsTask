//
//  NewsPresenterTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import XCTest
import NewsTask

struct NewsViewModel {
    let news: [NewsImage]
}

protocol NewsView {
    func display(_ viewModel: NewsViewModel)
}

struct NewsErrorViewModel {
    let message: String?

    static var noError: NewsErrorViewModel {
        return NewsErrorViewModel(message: nil)
    }
}

struct NewsLoadingViewModel {
    let isLoading: Bool
}

protocol NewsLoadingView {
    func display(_ viewModel: NewsLoadingViewModel)
}

protocol NewsErrorView {
    func display(_ viewModel: NewsErrorViewModel)
}

final class NewsPresenter {
    private let newsView: NewsView
    private let loadingView: NewsLoadingView
    private let errorView: NewsErrorView
    
    init(newsView: NewsView,loadingView: NewsLoadingView, errorView: NewsErrorView) {
        self.newsView = newsView
        self.loadingView = loadingView
        self.errorView = errorView
    }
    
    func didStartLoadingNews() {
        errorView.display(.noError)
        loadingView.display(NewsLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingNews(with news: [NewsImage]) {
        newsView.display(NewsViewModel(news: news))
        loadingView.display(NewsLoadingViewModel(isLoading: false))
    }
}


final class NewsPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingNews_displaysNoErrorMessageAndStartsLoading() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingNews()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    func test_didFinishLoadingNews_displaysNewsAndStopsLoading() {
        let (sut, view) = makeSUT()
        let news = uniqueImageNews()
        
        sut.didFinishLoadingNews(with: news)
        
        XCTAssertEqual(view.messages, [
            .display(news: news),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: NewsPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = NewsPresenter(newsView: view,loadingView: view,errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy:NewsView, NewsLoadingView, NewsErrorView {
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(news: [NewsImage])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: NewsErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: NewsLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: NewsViewModel) {
            messages.insert(.display(news: viewModel.news))
        }
    }
    
    private func uniqueImageNews() -> [NewsImage] {
        [
            NewsImage(source: "a source", title: "a title", description: nil, date: Date(), url: URL(string: "http://a.url.com")!),
            NewsImage(source: "another source", title: "another title", description: nil, date: Date(), url: URL(string: "http://another.url.com")!)
        ]
    }
    
}
