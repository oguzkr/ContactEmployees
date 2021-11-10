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
        configureTableView()
        bindEmployeeData()
    }
    
    func bindEmployeeData(){
        if let selectedEmployee = employee {
            labelFullName.text = "\(selectedEmployee.fname) \(selectedEmployee.lname)"
            
            labelPosition.text = selectedEmployee.position
            
            selectedEmployee.contact_details?.phone == nil ? (labelPhone.isHidden = true) : (labelPhone.text = selectedEmployee.contact_details?.phone)
            
            labelEmail.text = selectedEmployee.contact_details?.email
        }
    }
    
    func configureTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Identifiers.projectCell)
    }

    //MARK: TablView Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.projectCell)!
            if let employeeProjects = employee?.projects {
                if employeeProjects.count > 0 {
                    cell.textLabel?.text = employeeProjects[indexPath.row]
                }
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 && employee?.projects == nil{
            return ""
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
