//
//  NewsRefreshController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

protocol NewsRefreshViewControllerDelegate {
    func didRequestNewsRefresh()
}

final class NewsRefreshController: NSObject, NewsLoadingView {
    private(set) lazy var view = loadView()
    
    private let delegate: NewsRefreshViewControllerDelegate
    
    init(delegate: NewsRefreshViewControllerDelegate) {
        self.delegate = delegate
    }
        
    @objc func refresh() {
        delegate.didRequestNewsRefresh()
    }
    
    func display(_ viewModel: NewsLoadingViewModel) {
        if viewModel.isLoading {
            view.beginRefreshing()
        } else {
            view.endRefreshing()
        }
    }
    
    private func loadView() -> UIRefreshControl  {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }
}
