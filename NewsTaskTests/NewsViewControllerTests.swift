//
//  NewsViewControllerTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import XCTest
import NewsTask

class NewsViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedNewsReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedNewsReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeNewsLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedNewsReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeNewsLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    func test_loadNewsCompletion_rendersSuccessfullyLoadedNews() {
        let image0 = makeImage(source: "a source", title: "a title")
        let image1 = makeImage(source: "another source", title: "another title")
        let image2 = makeImage(source: "any another source", title: "any another title")
        let image3 = makeImage(source: "source", title: "title")
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        assertThat(sut, isRendering: [])
        
        loader.completeNewsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedNewsReload()
        loader.completeNewsLoading(with: [image0, image1, image2, image3], at: 1)
        assertThat(sut, isRendering: [image0, image1, image2, image3])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: NewsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = NewsViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    private func assertThat(
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
    
    private func assertThat(
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
    
    private func makeImage(
        source: String = "a source",
        title: String = "a title",
        description: String? = nil,
        date: Date = Date(),
        url: URL = URL(string: "http://any-url.com")!
    ) -> NewsImage {
        NewsImage(source: source, title: title, description: description, date: date, url: url)
    }
    
    class LoaderSpy: NewsLoader {
        private var completions = [(NewsLoader.Result) -> Void]()
        
        var loadCallCount: Int {
            completions.count
        }
        
        func load(completion: @escaping (NewsLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeNewsLoading(with news:[NewsImage] = [],at index: Int) {
            completions[index](.success(news))
        }
    }
}

private extension NewsViewController {
    func simulateUserInitiatedNewsReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func numberOfRenderedNewsImageViews() -> Int {
        return tableView.numberOfRows(inSection: newsImagesSection)
    }
    
    func newsImageView(at row: Int) -> UITableViewCell? {
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: newsImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var newsImagesSection: Int {
        return 0
    }
}

private extension NewsImageCell {
    var sourceText: String? {
        return sourceLabel.text
    }

    var titleText: String? {
        return titleLabel.text
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

