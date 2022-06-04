//
//  NewsImageCell.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit
import SwiftUI

public final class NewsImageCell: UITableViewCell {

    // MARK: - Views
    
    private(set) public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private(set) public lazy var sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .blue
        return label
    }()
    
    private(set) public lazy var timeAgoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    
    private(set) public lazy var newsImageContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) public lazy var newsImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private(set) public lazy var newsImageRetryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .lightGray
        button.setTitle("↻", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.titleLabel?.textColor = .black
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var onRetry: (() -> Void)?

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    private func setupViews() {
        configureNewsImage()
        configureTitle()
        configureSource()
        configureTimeAgo()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        contentView.backgroundColor = .clear
        let margins = UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
        contentView.frame = contentView.frame.inset(by: margins)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12
    }
    
    private func configureNewsImage() {
        contentView.addSubview(newsImageContainer)
        newsImageContainer.addSubview(newsImageView)
        newsImageContainer.addSubview(newsImageRetryButton)

        NSLayoutConstraint.activate([
            newsImageContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            newsImageContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            newsImageContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            newsImageContainer.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            newsImageView.widthAnchor.constraint(equalTo: newsImageContainer.widthAnchor),
            newsImageView.heightAnchor.constraint(equalTo: newsImageContainer.heightAnchor),
            
            newsImageRetryButton.widthAnchor.constraint(equalTo: newsImageContainer.widthAnchor),
            newsImageRetryButton.heightAnchor.constraint(equalTo: newsImageContainer.heightAnchor),
        ])
    }
    
    private func configureTitle() {
        titleLabel.text = "this a b"
        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor,constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: newsImageContainer.trailingAnchor,constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
        ])
    }
    
    private func configureSource() {
        sourceLabel.text = "this a b"
        contentView.addSubview(sourceLabel)
        NSLayoutConstraint.activate([
            sourceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: -12),
            sourceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
        ])
    }
    
    private func configureTimeAgo() {
        timeAgoLabel.text = "1 hour ago"
        contentView.addSubview(timeAgoLabel)
        NSLayoutConstraint.activate([
            timeAgoLabel.leadingAnchor.constraint(equalTo: newsImageContainer.trailingAnchor,constant: 12),
            timeAgoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -8),
        ])
    }
    
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Preivew

struct NewsImageCellPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 400, height: 100))
    }
    
    struct ContentView: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            NewsImageCell(style: .default, reuseIdentifier: "Reuse")
        }
        
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }
}
