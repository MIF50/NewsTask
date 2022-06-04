//
//  NewsViewControllerTests+localization.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import Foundation
import NewsTask
import XCTest

extension NewsViewControllerTests {
    func localized(
        _ key: String,
        file: StaticString = #file,
        line: UInt = #line
    ) -> String {
        let table = "News"
        let bundle = Bundle(for: NewsViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
