//
//  ServiceType.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import Foundation

struct ServiceType {
    static func employees(branch: Branch) -> String {
        switch branch {
        case .tartu:
            return "https://tartu-jobapp.aw.ee/employee_list/"
        case .tallinn:
            return "https://tallinn-jobapp.aw.ee/employee_list/"
        }
    }
}

enum Branch {
    case tartu, tallinn
}
