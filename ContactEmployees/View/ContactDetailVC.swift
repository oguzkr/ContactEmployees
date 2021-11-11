//
//  ContactDetailVC.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 10.11.2021.
//

import UIKit

class ContactDetailVC: UITableViewController {

    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPosition: UILabel!
    
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    
    @IBOutlet weak var labelProjects: UILabel!
    
    var employee : Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmployeeData()
    }
    
    func bindEmployeeData(){
        if let selectedEmployee = employee {
            labelFullName.text = "\(selectedEmployee.fname) \(selectedEmployee.lname)"
            
            labelPosition.text = selectedEmployee.position
            
            selectedEmployee.contact_details?.phone == nil ? (labelPhone.isHidden = true) : (labelPhone.text = selectedEmployee.contact_details?.phone)
            
            labelEmail.text = selectedEmployee.contact_details?.email
            
            if let projects = selectedEmployee.projects {
                labelProjects.text = projects.joined(separator: ", ")
            }
        }
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 && employee?.projects == nil{
            return ""
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }




}
