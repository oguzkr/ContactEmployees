//
//  StringExtension.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 12.11.2021.
//

import Foundation

extension String {
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
