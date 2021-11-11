//
//  ContactsVC.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import UIKit

class ContactsVC: UIViewController {

    let apiClient: ApiClient = ApiClient()
    let refreshControl = UIRefreshControl()

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
                self.employees.sort(by: { $0.lname.lowercased() < $1.lname.lowercased() })
                self.configureTableView()
            } else {
                self.showAlert(message: "Task failed successfully")
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func getEmployeesFromTallinn(){
        apiClient.getEmployees(branch: .tallinn) { success in
            if success {
                self.employees.append(contentsOf: self.apiClient.employees)
                self.employees.sort(by: { $0.lname.lowercased() < $1.lname.lowercased() })
                self.configureTableView()
            } else {
                self.showAlert(message: "Task failed successfully")
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func configureTableView(){
        tableView.register(UINib(nibName: EmployeeTVCell.reuseID, bundle: nil), forCellReuseIdentifier: Identifiers.employeeCell)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        removeDuplicates()
        tableView.reloadData()
     }
    
    @objc func refreshData(_ sender: AnyObject) {
        getEmployeesFromTartu()
        getEmployeesFromTallinn()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.employeeDetailSegueId
        {
            let contactDetailVC = segue.destination as! ContactDetailVC
            contactDetailVC.employee = selectedEmployee
        }
    }
    
    func showAlert(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func removeDuplicates(){
        let removedDuplicateEmployees =  employees.uniques(by: \.fname, \.lname)
        employees = removedDuplicateEmployees
    }
}


extension ContactsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.employeeCell, for: indexPath) as! EmployeeTVCell
        
        let fullName = "\(employees[indexPath.row].fname) \(employees[indexPath.row].lname)"
        let email = employees[indexPath.row].contact_details?.email
        
        cell.labelFullName.text = fullName
        cell.labelPosition.text = email
        
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
