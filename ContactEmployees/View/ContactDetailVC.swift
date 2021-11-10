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
    
    var employee : Employee?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindEmployeeData()
        tableView.register(UINib(nibName: ProjectCell.reuseID, bundle: nil), forCellReuseIdentifier: Identifiers.projectCell)
    }
    
    func bindEmployeeData(){
        if let selectedEmployee = employee {
            labelFullName.text = "\(selectedEmployee.fname) \(selectedEmployee.lname)"
            labelPosition.text = selectedEmployee.position
            selectedEmployee.contact_details?.phone == nil ? (labelPhone.isHidden = true) : (labelPhone.text = selectedEmployee.contact_details?.phone)
            labelEmail.text = selectedEmployee.contact_details?.email
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.projectCell, for: indexPath) as! ProjectCell

            if let employeeProjects = employee?.projects {
                if employeeProjects.count > 0 {
                    cell.labelProject.text = employeeProjects[indexPath.row]
                }
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3  {
            if employee?.projects == nil {
                return ""
            }
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let employeeProjects = employee?.projects {
            if section == 3 {
                return employeeProjects.count
            }
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }



}
