//
//  NewsSnapshotTests.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 05/06/2022.
//

import XCTest
@testable import NewsTask

class NewsSnapshotTests: XCTestCase {
    
    func test_emptyNews() {
        let sut = makeSUT()

        sut.display(emptyFeed())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "EMPTY_NEWS")
    }
    
    func test_newsWithContent() {
        let sut = makeSUT()

        sut.display(feedWithContent())

        assert(snapshot: sut.snapshot(for: .iPhone13(style: .light)), named: "NEWS_WITH_CONTENT")
    }
    
    // MARK: - Helpers
    private func makeSUT() -> NewsViewController {
        let controller = NewsViewController()
        controller.loadViewIfNeeded()
        return controller
    }
    
    private func emptyFeed() -> [NewsImageCellController] {
        return []
    }
    
    private func feedWithContent() -> [ImageStub] {
            return [
                ImageStub(
                    title: "Musk threatens to drop Twitter deal if fake-account data not provided - Reuters",
                    source: "Reuters",
                    timeAgo: "1 hour ago",
                    image:UIImage.make(withColor: .red)
                ),
                ImageStub(
                    title: "Apple CarPlay is expanding with new features that can integrate deeper into the car - The Verge",
                    source: "The Verge",
                    timeAgo: "1 minute ago",
                    image: UIImage.make(withColor: .green)
                ),
                ImageStub(
                    title: "Apple announces its next-gen M2 chip",
                    source: "Ars Technica",
                    timeAgo: "1 second ago",
                    image: UIImage.make(withColor: .cyan)
                )
            ]
        }
    
}

private extension NewsViewController {
    func display(_ stubs: [ImageStub]) {
        let cells: [NewsImageCellController] = stubs.map { stub in
            let cellController = NewsImageCellController(delegate: stub,selection: {})
            stub.controller = cellController
            return cellController
        }

        display(cells)
    }
}

private class ImageStub: NewsImageCellControllerDelegate {
    let viewModel: NewsImageViewModel<UIImage>
    weak var controller: NewsImageCellController?

    init(title: String, source: String,timeAgo: String, image: UIImage?) {
        viewModel = NewsImageViewModel(
            title: title,
            source: source,
            image: image,
            timeAgo: timeAgo,
            isLoading: false,
            shouldRetry: image == nil
        )
    }

    func didRequestImage() {
        controller?.display(viewModel)
    }

    func didCancelImageRequest() {}
}
