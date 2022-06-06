//
//  HTTPURLResponse+StatusCode.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}
