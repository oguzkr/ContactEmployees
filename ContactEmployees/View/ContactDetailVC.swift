//
//  ContactDetailVC.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import UIKit

class ContactDetailVC: UIViewController {

    var employee : Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmployeeData()
    }
    
    func bindEmployeeData(){
        print(employee!)
    }

}
