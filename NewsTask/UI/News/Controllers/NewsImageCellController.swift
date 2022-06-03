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
    private var cell: NewsImageCell?
    
    init(delegate: NewsImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewsImageCell") as! NewsImageCell
        self.cell = cell
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        cell = nil
        delegate.didCancelImageRequest()
    }
    
    func display(_ viewModel: NewsImageViewModel<UIImage>) {
        cell?.titleLabel.text = viewModel.title
        cell?.sourceLabel.text = viewModel.source
        
        cell?.newsImageView.image = viewModel.image
        cell?.newsImageContainer.isShimmering = viewModel.isLoading
        cell?.newsImageRetryButton.isHidden = !viewModel.shouldRetry
        
        cell?.onRetry = delegate.didRequestImage
    }
}

