//
//  UIButton+TestHelpers.swift
//  NewsTaskTests
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}
