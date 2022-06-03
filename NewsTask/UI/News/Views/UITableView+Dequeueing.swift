//
//  UITableView+Dequeueing.swift
//  NewsTask
//
//  Created by Mohamed Ibrahim on 03/06/2022.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}

extension UITableView {
    func register<T: UITableViewCell>(cell: T.Type) {
        let identifier = String(describing: T.self)
        self.register(T.self, forCellReuseIdentifier: identifier)
    }
}

