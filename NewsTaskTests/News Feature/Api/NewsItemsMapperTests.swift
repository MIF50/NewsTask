//
//  NewsItemsMapperTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 06/06/2022.
//

import XCTest
import NewsTask

class NewsItemsMapperTests: XCTestCase {
    
    func test_mapper_throwsErrorOnNon200HTTPResponse() throws {
        let json = makeItemsJSON([])
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach({ code in
            XCTAssertThrowsError(
                try NewsItemMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        })
    }
    
    func test_mapper_thowsErrorOn200HTTPResponseWithInvalidJSON() {
        let invalidJSON = Data("invalid json".utf8)

        XCTAssertThrowsError(
            try NewsItemMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let emptyListJSON = makeItemsJSON([])

        let result = try NewsItemMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
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

        let json = makeItemsJSON([item1.json, item2.json])

        let result = try NewsItemMapper.map(json, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [item1.model, item2.model])
    }    
    
    // MARK: - Helpers
    
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
