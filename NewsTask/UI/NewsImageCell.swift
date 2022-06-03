//
//  NewsImageCell.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

public final class NewsImageCell: UITableViewCell {
    
    public let sourceLabel: UILabel = UILabel()
    public let titleLabel: UILabel = UILabel()
    public let newsImageContainer: UIView = UIView()
    public let newsImageView = UIImageView()
    
    private(set) public lazy var newsImageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onRetry: (() -> Void)?
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
}
