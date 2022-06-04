//
//  NewsPresenterTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import XCTest
import NewsTask

struct NewsErrorViewModel {
    let message: String?

    static var noError: NewsErrorViewModel {
        return NewsErrorViewModel(message: nil)
    }
}

protocol NewsErrorView {
    func display(_ viewModel: NewsErrorViewModel)
}

final class NewsPresenter {
    private let errorView: NewsErrorView
    
    init(errorView: NewsErrorView) {
        self.errorView = errorView
    }
    
    func didStartLoadingNews() {
        errorView.display(.noError)
    }
}


final class NewsPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingNews()
        
        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: NewsPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = NewsPresenter(errorView: view)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: NewsErrorView {
        enum Message: Equatable {
            case display(errorMessage: String?)
        }
        
        private(set) var messages = [Message]()
        
        func display(_ viewModel: NewsErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
    }
    
}
