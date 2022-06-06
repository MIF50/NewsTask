//
//  NewsAcceptanceTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 05/06/2022.
//

import XCTest
@testable import NewsTask

final class NewsAcceptanceTests: XCTestCase {
    
        func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
//            let news = launch(httpClient: .online(response))
//
//            XCTAssertEqual(news.numberOfRenderedNewsImageViews(), 2)
//            XCTAssertEqual(news.renderedNewsImageData(at: 0), makeImageData())
//            XCTAssertEqual(news.renderedNewsImageData(at: 1), makeImageData())
        }
    
        // MARK: - Helpers
    
        private func launch(
            httpClient: HTTPClientStub
        ) -> NewsViewController {
            let sut = SceneDelegate(httpClient: httpClient)
            sut.window = UIWindow()
            sut.configureWindow()
    
            let nav = sut.window?.rootViewController as? UINavigationController
            return nav?.topViewController as! NewsViewController
        }
    
        private func response(for url: URL) -> (Data, HTTPURLResponse) {
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (makeData(for: url), response)
        }
    
        private func makeImageData() -> Data {
            return UIImage.make(withColor: .red).pngData()!
        }
    
        private func makeData(for url: URL) -> Data {
            switch url.path {
            case "/image-1", "/image-2":
                return makeImageData()
            default:
                return makeNewsData()
            }
        }
    
        private func makeNewsData() -> Data {
            return try! JSONSerialization.data(withJSONObject: ["articles": [
                [
                    "source":[
                        "name": "The Wall Street Journal"
                    ],
                    "title": "Gay Travelers Gather",
                    "description":"Gay Travelers Gather at DISNEY",
                    "publishedAt":"2021-08-28T15:07:02Z",
                    "urlToImage": "http://news.com/image-1"
                ],
                [
                    "source":[
                        "name":"The Wall Street Journal"
                    ],
                    "title": "Gay Travelers Gather",
                    "description":"Gay Travelers Gather at DISNEY",
                    "publishedAt":"2022-06-04T14:49:50Z",
                    "urlToImage": "http://news.com/image-2"
                ]
            ]])
        }
}
