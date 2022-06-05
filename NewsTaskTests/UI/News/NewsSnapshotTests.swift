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
//        let sut = makeSUT()
//
//        sut.display(emptyFeed())
//
//        record(snapshot: sut.snapshot(), named: "EMPTY_NEWS")
    }
    
    func test_newsWithContent() {
//        let sut = makeSUT()
//
//        sut.display(feedWithContent())
//
//        record(snapshot: sut.snapshot(), named: "NEWS_WITH_CONTENT")
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
    
    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))
            .deletingLastPathComponent()
            .appendingPathComponent("snapshots")
            .appendingPathComponent("\(name).png")
        
        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            
            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error: \(error)", file: file, line: line)
        }
    }
    
    
    private func feedWithContent() -> [ImageStub] {
            return [
                ImageStub(
                    title: "he East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wal",
                    source: "BBC",
                    timeAgo: "1 hour ago",
                    image:UIImage.make(withColor: .red)
                ),
                ImageStub(
                    title: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                    source: "BBC",
                    timeAgo: "1 minute ago",
                    image: UIImage.make(withColor: .green)
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

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}
