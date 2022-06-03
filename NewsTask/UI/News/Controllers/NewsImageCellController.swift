//
//  NewsImageCellController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

protocol NewsImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class NewsImageCellController: NewsImageView {
    private let delegate: NewsImageCellControllerDelegate
    let cell = NewsImageCell()
    
    init(delegate: NewsImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view() -> UITableViewCell {
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        delegate.didCancelImageRequest()
    }
    
    func display(_ viewModel: NewsImageViewModel<UIImage>) {
        cell.titleLabel.text = viewModel.title
        cell.sourceLabel.text = viewModel.source
        
        cell.newsImageView.image = viewModel.image
        cell.newsImageContainer.isShimmering = viewModel.isLoading
        cell.newsImageRetryButton.isHidden = !viewModel.shouldRetry
        
        cell.onRetry = delegate.didRequestImage
    }
}

