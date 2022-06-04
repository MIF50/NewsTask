//
//  NewsViewController+Assertions.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import XCTest
import UIKit
import NewsTask

extension NewsUIIntegrationTests {
    
    func assertThat(
        _ sut: NewsViewController,
        isRendering news: [NewsImage],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard sut.numberOfRenderedNewsImageViews() == news.count else {
            return XCTFail("Expected \(news.count) images, got \(sut.numberOfRenderedNewsImageViews()) instead.", file: file, line: line)
        }
        
        news.enumerated().forEach { index, image in
            assertThat(sut, hasViewConfiguredFor: image, at: index, file: file, line: line)
        }
    }
    
    func assertThat(
        _ sut: NewsViewController,
        hasViewConfiguredFor image: NewsImage,
        at index: Int,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let view = sut.newsImageView(at: index)
        
        guard let cell = view as? NewsImageCell else {
            return XCTFail("Expected \(NewsImageCell.self) instance, got \(String(describing: view)) instead", file: file, line: line)
        }
        
        XCTAssertEqual(cell.sourceText, image.source, "Expected source text to be \(String(describing: image.source)) for image view at index (\(index))", file: file, line: line)
        
        XCTAssertEqual(cell.titleText, image.title, "Expected title text to be \(String(describing: image.description)) for image view at index (\(index)", file: file, line: line)
    }
}
