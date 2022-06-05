//
//  NewsImageDataMapper.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 05/06/2022.
//

import Foundation

public final class NewsImageDataMapper {
    public enum Error: Swift.Error {
        case invalidData
    }

    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard response.isOK, !data.isEmpty else {
            throw Error.invalidData
        }

        return data
    }
}
