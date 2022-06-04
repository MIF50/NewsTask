//
//  NewsPresenterTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import XCTest
import NewsTask

final class NewsPresenter {
    init(view: Any) {

    }
}
final class NewsPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let view = ViewSpy()
        
        _ = NewsPresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }
    
}
