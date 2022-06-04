//
//  NewsImageDataLoader.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

public protocol NewsImageDataLoaderTask {
    func cancel()
}

public protocol NewsImageDataLoader {
    typealias Result = Swift.Result<Data, Error>

    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> NewsImageDataLoaderTask
}
