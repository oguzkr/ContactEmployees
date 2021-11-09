//
//  ContactsVC.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import UIKit

class ContactsVC: UIViewController {

    let apiClient: ApiClient = ApiClient()
    var employees = [Employee]()
    var selectedEmployee : Employee?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployeesFromTartu()
        getEmployeesFromTallinn()
    }
    
    func getEmployeesFromTartu(){
        apiClient.getEmployees(branch: .tartu) { success in
            if success {
                self.employees = self.apiClient.employees
                self.employees.append(contentsOf: self.apiClient.employees)
                self.configureTableView()
            } else {
                //error
            }
        }
    }
    
    func getEmployeesFromTallinn(){
        apiClient.getEmployees(branch: .tallinn) { success in
            if success {
                self.employees.append(contentsOf: self.apiClient.employees)
                self.configureTableView()
            } else {
                //error
            }
        }
    }
    
    func configureTableView(){
        tableView.register(UINib(nibName: EmployeeTVCell.reuseID, bundle: nil), forCellReuseIdentifier: Identifiers.employeeCell)
         tableView.reloadData()
     }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.employeeDetailSegueId
        {
            let contactDetailVC = segue.destination as! ContactDetailVC
            contactDetailVC.employee = selectedEmployee
        }
    }
}


extension ContactsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.employeeCell, for: indexPath) as! EmployeeTVCell
        
        let fullName = "\(employees[indexPath.row].fname) \(employees[indexPath.row].lname)"
        let position = employees[indexPath.row].position
        
        cell.labelFullName.text = fullName
        cell.labelPosition.text = position
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedEmployee = employees[indexPath.row]
        performSegue(withIdentifier: Identifiers.employeeDetailSegueId, sender: self)
    }

}


