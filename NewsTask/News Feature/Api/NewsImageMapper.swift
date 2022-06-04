//
//  FeedImageMapper.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation

enum NewsImageMapper {
    private struct Root: Decodable {
        let articles: [Item]
        var news: [NewsImage] {
            return articles.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let title: String
        let description: String?
        let urlToImage: URL?
        let source: Source
        let publishedAt: Date

        var item: NewsImage {
            return .init(source: source.name,
                         title: title,
                         description: description,
                         date: publishedAt,
                         url: urlToImage ?? URL(string: "http://url.com")!
            )
        }
        
        struct Source: Decodable {
            let name: String
        }
    }

    static func map(_ data: Data, from response: HTTPURLResponse) -> NewsLoader.Result {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        guard response.isOK,
              let root = try? decoder.decode(Root.self, from: data)
        else {
            return .failure(RemoteNewsLoader.Error.invalidData)
        }
        return .success(root.news)
    }
}
