//
//  Employee.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import Foundation
import Contacts

struct EmployeeModel:Decodable {
    var employees: [Employee]?
}

struct Employee:Decodable {
    var fname, lname, position: String
    var contact_details: ContactDetails?
    var projects: [String]?
}

struct ContactDetails:Decodable {
    var email, phone: String?
}
