//
//  NewsRefreshController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

final class NewsRefreshController: NSObject, NewsLoadingView {
    private(set) lazy var view = loadView()
    
    private let presenter: NewsPresenter
    
    init(presenter: NewsPresenter) {
        self.presenter = presenter
    }
        
    @objc func refresh() {
        presenter.loadNews()
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
