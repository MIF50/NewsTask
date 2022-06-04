//
//  NewsDetailsViewController.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import UIKit
import SwiftUI

class NewsDetailsViewController: UIViewController {
    
    // MARK: - View
    private(set) public lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .red
        return iv
    }()
    
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
    
    private(set) public lazy var infoContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.backgroundColor = .yellow
        return view
    }()
    
    private(set) public lazy var descLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .systemGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    
}

// MARK: - Configure UI
extension NewsDetailsViewController {
    
    private func setupViews() {
        configureImageView()
        configureInfoContainer()
        configureDescLabel()
    }
    
    private func configureImageView() {
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureInfoContainer() {
        titleLabel.text = "Hi"
        sourceLabel.text = "CCC"
        timeAgoLabel.text = "1 hour ago"
        
        view.addSubview(infoContainer)
        NSLayoutConstraint.activate([
            infoContainer.bottomAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 50),

            infoContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            infoContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
            infoContainer.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        infoContainer.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: infoContainer.topAnchor,constant: 22),
            titleLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor,constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor,constant: -12),
        ])
        
        infoContainer.addSubview(sourceLabel)
        NSLayoutConstraint.activate([
            sourceLabel.trailingAnchor.constraint(equalTo: infoContainer.trailingAnchor,constant: -12),
            sourceLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor,constant: -8),
        ])
        
        infoContainer.addSubview(timeAgoLabel)
        NSLayoutConstraint.activate([
            timeAgoLabel.leadingAnchor.constraint(equalTo: infoContainer.leadingAnchor,constant: 12),
            timeAgoLabel.bottomAnchor.constraint(equalTo: infoContainer.bottomAnchor,constant: -8),
        ])
    }
    
    private func configureDescLabel() {
        view.addSubview(descLabel)
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: infoContainer.bottomAnchor,constant: 20),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20),
        ])
    }

}

// MARK: - Preview
struct NewsDetailsViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    struct ContentView: UIViewControllerRepresentable {
        func makeUIViewController(context: Context) -> some UIViewController {
            NewsDetailsViewController()
        }
        
        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
