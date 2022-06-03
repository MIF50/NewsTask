//
//  NewsImageCellController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

final class NewsImageCellController {
    
    private let viewModel: NewsImageViewModel<UIImage>
    
    init(viewModel: NewsImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }
    
    func view() -> UITableViewCell {
        let cell = binded(NewsImageCell())
        viewModel.LoadImageData()
        return cell
    }
    
    func preload() {
        viewModel.LoadImageData()
    }
    
    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }
    
    private func binded(_ cell: NewsImageCell) -> NewsImageCell {
        cell.titleLabel.text = viewModel.title
        cell.sourceLabel.text = viewModel.source
        cell.onRetry = viewModel.LoadImageData
        
        viewModel.onImageLoad = { [weak cell] image in
            cell?.newsImageView.image = image
        }
        
        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.newsImageContainer.isShimmering = isLoading
        }
        
        viewModel.onShouldRetryImageLoadingStateChange = { [weak cell] shouldRetry in
            cell?.newsImageRetryButton.isHidden = !shouldRetry
        }
        return cell
    }
}

