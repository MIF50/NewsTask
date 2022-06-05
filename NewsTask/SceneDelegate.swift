//
//  SceneDelegate.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit
import Combine

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1
    // https://newsapi.org/v2/everything?domains=wsj.com&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1
    private lazy var remoteURL: URL = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1")!
    private lazy var httpClient: HTTPClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    
    private lazy var navigationController = UINavigationController(
        rootViewController: NewsUIComposer.composedWith(newsLoader: makeRemoteNewsLoader,
                                                        imageLoader: makeRemoteImageLoader,
                                                        selection: showDetails))

    convenience init(httpClient: HTTPClient) {
        self.init()
        self.httpClient = httpClient
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    private func showDetails(for image: NewsImage) {
        let loader = makeRemoteImageLoader(url: image.url)
        let detailsController = DetailsUIComposer.composedWith(imageLoader: { loader },news: image )
        navigationController.show(detailsController, sender: nil)
    }
    
    private func makeRemoteNewsLoader() -> NewsLoader.Publisher {
        let url = URL(string: "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1")!

//        let url = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1")!
        return httpClient
            .getPublisher(url: url)
            .tryMap(NewsImageMapper.map)
            .eraseToAnyPublisher()

    }

    private func makeRemoteImageLoader(url: URL) -> NewsImageDataLoader.Publisher {
        return httpClient
            .getPublisher(url: url)
            .tryMap(NewsImageDataMapper.map)
            .eraseToAnyPublisher()
    }
}

