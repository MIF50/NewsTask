//
//  DetailsPresenter.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 05/06/2022.
//

import Foundation

protocol DetailsLoadingView {
    func display(_ viewModel: NewsLoadingViewModel)
}

struct DetailsViewModel {
    let data: Data
}

protocol DetailsView {
    func display(_ viewModel: DetailsViewModel)
}

class DetailsPresenter {
    private let detailsView: DetailsView
    private let loadingView: DetailsLoadingView
    
    init(detailsView: DetailsView,loadingView: DetailsLoadingView) {
        self.detailsView = detailsView
        self.loadingView = loadingView
    }
    
    func didStartLoadingNews() {
        loadingView.display(NewsLoadingViewModel(isLoading: true))
    }
    
    func didFinishLoadingNews(with data: Data) {
        detailsView.display(DetailsViewModel(data: data))
        loadingView.display(NewsLoadingViewModel(isLoading: false))
    }
    
    func didFinishLoadingNews(with error: Error) {
       loadingView.display(NewsLoadingViewModel(isLoading: false))
    }
}
