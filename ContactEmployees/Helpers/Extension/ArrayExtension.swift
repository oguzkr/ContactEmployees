//
//  ArrayExtension.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 11.11.2021.
//

import Foundation

extension Array {
    func uniques<T: Hashable>(by keyPath1: KeyPath<Element, T>, _ keyPath2: KeyPath<Element, T>) -> [Element] {
        return reduce([]) { result, element in
            let alreadyExists = (result.contains(where: { $0[keyPath: keyPath1] == element[keyPath: keyPath1] && $0[keyPath: keyPath2] == element[keyPath: keyPath2] }))
            return alreadyExists ? result : result + [element]
        }
    }
}
