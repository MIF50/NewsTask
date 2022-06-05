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
    let selection: () -> Void

    
    init(delegate: NewsImageCellControllerDelegate,selection:@escaping () -> Void) {
        self.delegate = delegate
        self.selection = selection
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }
    
    func display(_ viewModel: NewsImageViewModel<UIImage>) {
        cell?.titleLabel.text = viewModel.title
        cell?.sourceLabel.text = viewModel.source
        
        cell?.newsImageView.setImageAnimated(viewModel.image)
        cell?.newsImageContainer.isShimmering = viewModel.isLoading
        cell?.newsImageRetryButton.isHidden = !viewModel.shouldRetry
        
        cell?.onRetry = delegate.didRequestImage
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}

