//
//  LoadNewsFromRemoteUseCaseTests+Helpers.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 04/06/2022.
//

import XCTest
import NewsTask

extension LoadNewsFromRemoteUseCaseTests {
    func expect(
        _ sut: RemoteNewsLoader,
        toCompleteWith expectedResult: Result<[NewsImage], RemoteNewsLoader.Error>,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
//                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                XCTAssertEqual(receivedItems.first?.source, expectedItems.first?.source, file: file, line: line)
                XCTAssertEqual(receivedItems.first?.title, expectedItems.first?.title, file: file, line: line)
                XCTAssertEqual(receivedItems.first?.url, expectedItems.first?.url, file: file, line: line)
                XCTAssertEqual(receivedItems.first?.description, expectedItems.first?.description, file: file, line: line)
                XCTAssertEqual(receivedItems.first?.date, expectedItems.first?.date, file: file, line: line)



            case let (.failure(receivedError as RemoteNewsLoader.Error), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
}
