//
//  NewsImageViewModel.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import Foundation

struct NewsImageViewModel<Image> {
    let title: String
    let source: String
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
}
