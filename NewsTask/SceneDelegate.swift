//
//  SceneDelegate.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    // https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1
    // https://newsapi.org/v2/everything?domains=wsj.com&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1
    private lazy var remoteURL: URL = URL(string: "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey=38452b3dbdc64b5aba76dc73c70fe3d1")!
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteNewsLoader = RemoteNewsLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteNewsImageDataLoader(client: remoteClient)
        
        let newsViewController = NewsUIComposer.composedWith(newsLoader: remoteNewsLoader,
                                                             imageLoader: remoteImageLoader)
        let rootController = UINavigationController(rootViewController: newsViewController)
        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }
}

