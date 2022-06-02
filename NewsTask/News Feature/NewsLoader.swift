//
//  NewsLoader.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 02/06/2022.
//

import Foundation

public protocol NewsLoader {
    typealias Result = Swift.Result<[NewsImage],Error>
    
    func load(completion: @escaping (Result) -> Void)
}
