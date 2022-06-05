//
//  NewsViewController+TestHelpers.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit
import NewsTask

extension NewsViewController {
    func simulateUserInitiatedNewsReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    @discardableResult
    func simulateNewsImageViewVisible(at index: Int)-> NewsImageCell? {
        return newsImageView(at: index) as? NewsImageCell
    }
    
    @discardableResult
    func simulateNewsImageViewNotVisible(at row: Int)-> NewsImageCell? {
        let view = simulateNewsImageViewVisible(at: row)
        
        let delegate = tableView.delegate
        let index = IndexPath(row: row, section: newsImagesSection)
        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: index)
        
        return view
    }
    
    func simulateNewsImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: newsImagesSection)
        ds?.tableView(tableView, prefetchRowsAt: [index])
    }
    
    func simulateNewsImageViewNotNearVisible(at row: Int) {
        simulateNewsImageViewNearVisible(at: row)
        
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: newsImagesSection)
        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
    
    func renderedNewsImageData(at index: Int) -> Data? {
        return simulateNewsImageViewVisible(at: index)?.renderedImage
    }
    
    func numberOfRenderedNewsImageViews() -> Int {
        return tableView.numberOfRows(inSection: newsImagesSection)
    }
    
    func newsImageView(at row: Int) -> UITableViewCell? {
        guard numberOfRenderedNewsImageViews() > row else { return nil }
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: newsImagesSection)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
    
    private var newsImagesSection: Int {
        return 0
    }
}
