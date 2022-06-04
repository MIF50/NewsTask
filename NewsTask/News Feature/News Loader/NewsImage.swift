//
//  NewImage.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import Foundation

public struct NewsImage: Hashable {
    public let source: String
    public let title: String
    public let description: String?
    public let date: Date
    public let url: URL
    
    public init(source: String,title: String,description: String?, date: Date,url: URL) {
        self.source = source
        self.title = title
        self.description = description
        self.date = date
        self.url = url
    }
}
