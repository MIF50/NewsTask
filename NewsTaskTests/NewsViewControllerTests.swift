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
        XCTAssertEqual(loader.loadNewsCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(loader.loadNewsCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.simulateUserInitiatedNewsReload()
        XCTAssertEqual(loader.loadNewsCallCount, 2, "Expected another loading request once user initiates a reload")
        
        sut.simulateUserInitiatedNewsReload()
        XCTAssertEqual(loader.loadNewsCallCount, 3, "Expected yet another loading request once user initiates another reload")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeNewsLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completes successfully")
        
        sut.simulateUserInitiatedNewsReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeNewsLoadingWithError(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completes with error")
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
    
    func test_loadNewsCompletion_doesNotAlterCurrentRenderingStateOnError() {
        let image0 = makeImage()
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNewsLoading(with: [image0], at: 0)
        assertThat(sut, isRendering: [image0])
        
        sut.simulateUserInitiatedNewsReload()
        loader.completeNewsLoadingWithError(at: 1)
        assertThat(sut, isRendering: [image0])
    }
    
    func test_newsImageView_loadsImageURLWhenVisible() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNewsLoading(with: [image0, image1],at: 0)
        
        XCTAssertEqual(loader.loadedImageURLs, [], "Expected no image URL requests until views become visible")
        
        sut.simulateNewsImageViewVisible(at: 0)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url], "Expected first image URL request once first view becomes visible")
        
        sut.simulateNewsImageViewVisible(at: 1)
        XCTAssertEqual(loader.loadedImageURLs, [image0.url, image1.url], "Expected second image URL request once second view also becomes visible")
    }
    
    func test_newsImageView_cancelsImageLoadingWhenNotVisibleAnymore() {
        let image0 = makeImage(url: URL(string: "http://url-0.com")!)
        let image1 = makeImage(url: URL(string: "http://url-1.com")!)
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNewsLoading(with: [image0, image1],at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [], "Expected no cancelled image URL requests until image is not visible")
        
        sut.simulateNewsImageViewNotVisible(at: 0)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url], "Expected one cancelled image URL request once first image is not visible anymore")
        
        sut.simulateNewsImageViewNotVisible(at: 1)
        XCTAssertEqual(loader.cancelledImageURLs, [image0.url, image1.url], "Expected two cancelled image URL requests once second image is also not visible anymore")
    }
    
    func test_newsImageViewLoadingIndicator_isVisibleWhileLoadingImage() {
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        loader.completeNewsLoading(with: [makeImage(), makeImage()],at: 0)
        
        let view0 = sut.simulateNewsImageViewVisible(at: 0)
        let view1 = sut.simulateNewsImageViewVisible(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, true, "Expected loading indicator for first view while loading first image")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected loading indicator for second view while loading second image")
        
        loader.completeImageLoading(at: 0)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for first view once first image loading completes successfully")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, true, "Expected no loading indicator state change for second view once first image loading completes successfully")
        
        loader.completeImageLoadingWithError(at: 1)
        XCTAssertEqual(view0?.isShowingImageLoadingIndicator, false, "Expected no loading indicator state change for first view once second image loading completes with error")
        XCTAssertEqual(view1?.isShowingImageLoadingIndicator, false, "Expected no loading indicator for second view once second image loading completes with error")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: NewsViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = NewsViewController(newsLoader: loader,imageLoader: loader)
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
}

private extension NewsViewController {
    func simulateUserInitiatedNewsReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateNewsImageViewVisible(at index: Int)-> NewsImageCell? {
        return newsImageView(at: index) as? NewsImageCell
    }
    
    func simulateNewsImageViewNotVisible(at row: Int) {
        let view = simulateNewsImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: newsImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
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
    
    var isShowingImageLoadingIndicator: Bool {
        return newsImageContainer.isShimmering
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

