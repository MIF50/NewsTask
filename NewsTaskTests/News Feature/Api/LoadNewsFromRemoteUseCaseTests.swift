//
//  LoadNewsFromRemoteUseCaseTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import XCTest
import NewsTask

class LoadNewsFromRemoteUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithPartiallyValidJSONItems() {
        let (sut, client) = makeSUT()
        
        let validItem = makeItem(
            title: "a title",
            source: "a source",
            publishedAt: (Date(timeIntervalSince1970: 1598627222), "2020-08-28T15:07:02+00:00"),
            imageURL: URL(string: "http://another-url.com")!
        ).json
        
        let invalidItem = ["invalid": "item"]
        
        let items = [validItem, invalidItem]
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let json = makeItemsJSON(items)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversSuccessWithItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()

        let item1 = makeItem(
            title: "a title",
            source: "a source",
            publishedAt: (Date(timeIntervalSince1970: 1654852022), "2022-06-10T09:07:02Z"),
            imageURL: URL(string: "http://a-url.com")!
        )

        let item2 = makeItem(
            title: "any title",
            source: "any source",
            description: "any description",
            publishedAt: (Date(timeIntervalSince1970: 1630163222), "2021-08-28T15:07:02Z"),
            imageURL: URL(string: "http://another-url.com")!
        )

        let items = [item1.model,item2.model]

        expect(sut, toCompleteWith: .success(items), when: {
            let json = makeItemsJSON([item1.json,item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteNewsLoader? = RemoteNewsLoader(url: url, client: client)

        var capturedResults = [RemoteNewsLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT(
        url: URL = anyURL(),
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: RemoteNewsLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteNewsLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func makeItem(
        title: String,
        source: String,
        description: String? = nil,
        publishedAt: (date: Date, stringDate: String),
        imageURL: URL
    ) -> (model: NewsImage, json: [String: Any]) {
        let item = NewsImage(source: source, title: title, description: description, date: publishedAt.date, url: imageURL)
        
        let json: [String: Any] = [
            "source": [
                "name": source
            ],
            "title": title,
            "description": description,
            "urlToImage": imageURL.absoluteString,
            "publishedAt": publishedAt.stringDate
        ].compactMapValues { $0 }
        
        return (item, json)
    }
    
    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        let json = ["articles": items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
}
