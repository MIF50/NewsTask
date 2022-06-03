//
//  NewsRefreshController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

final class NewsRefreshController: NSObject {
    private(set) lazy var view = binded(UIRefreshControl())
    
    private let viewModel: NewsViewModel
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
    }
        
    @objc func refresh() {
        viewModel.loadNews()
    }
    
    private func binded(_ view: UIRefreshControl) -> UIRefreshControl  {
        viewModel.onChange = { [weak self] viewModel in
            if viewModel.isLoading {
                self?.view.beginRefreshing()
            } else {
                self?.view.endRefreshing()
            }
        }
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        return view
    }
}
