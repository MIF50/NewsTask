//
//  NewsImageCell+TestHelpers.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit
import NewsTask

extension NewsImageCell {
    func simulateRetryAction() {
        newsImageRetryButton.simulateTap()
    }
    
    var sourceText: String? {
        return sourceLabel.text
    }

    var titleText: String? {
        return titleLabel.text
    }
    
    var isShowingImageLoadingIndicator: Bool {
        return newsImageContainer.isShimmering
    }
    
    var isShowingRetryAction: Bool {
        return !newsImageRetryButton.isHidden
    }
    
    var renderedImage: Data? {
        return newsImageView.image?.pngData()
    }
}
