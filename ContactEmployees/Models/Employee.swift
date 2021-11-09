//
//  Employee.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import Foundation

struct EmployeeModel:Decodable {
    var employees: [Employee]?
}

struct Employee:Decodable {
    var fname, lname, position: String
    var contactDetails: ContactDetails?
    var projects: [String]?
}

struct ContactDetails:Decodable {
    var email, phone: String?
}
