//
//  FeedImageMapper.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation

public enum NewsItemMapper {
    private struct Root: Decodable {
        let articles: [Item]
        
        var news: [NewsImage] {
            return articles.map { $0.item }
        }
    }

    private struct Item: Decodable {
        let title: String
        let description: String?
        let urlToImage: URL
        let source: Source
        let publishedAt: Date

        var item: NewsImage {
            return .init(source: source.name,
                         title: title,
                         description: description,
                         date: publishedAt,
                         url: urlToImage
            )
        }
        
        struct Source: Decodable {
            let name: String
        }
    }
    
    public enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [NewsImage] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Shourt)
        guard response.isOK, let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }

        return root.news
    }
}

private extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.S'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let iso8601Shourt: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
