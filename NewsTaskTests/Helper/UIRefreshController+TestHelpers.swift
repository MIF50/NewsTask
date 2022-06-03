//
//  UIRefreshController+TestHelpers.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        simulate(event: .valueChanged)
    }
}
