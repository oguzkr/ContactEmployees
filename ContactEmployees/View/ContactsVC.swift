//
//  ContactsVC.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 9.11.2021.
//

import UIKit
import ContactsUI

class ContactsVC: UIViewController, CNContactViewControllerDelegate {

    let viewModel: EmployeesViewModel = EmployeesViewModel()
    let contactHelper = ContactHelper()
    let refreshControl = UIRefreshControl()
    
    var employees = [Employee]()
    var selectedEmployee : Employee?
    var employeePositions = [String]()
    var loader = SpinnerView()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getEmployeesFromTartu()
        checkContactPermission()
        showLoader()
    }
    
    func checkContactPermission(){
        requestAccess()
        if CNContactStore.authorizationStatus(for: .contacts) == .authorized {
            contactHelper.getContacts()
        } else {
            presentSettingsActionSheet()
        }
    }

    func requestAccess() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { granted, error in
            guard granted else {
                DispatchQueue.main.async {
                   self.presentSettingsActionSheet()
                }
                return
            }
        }
    }

    func presentSettingsActionSheet() {
        let alert = UIAlertController(title: "Permission to Contacts", message: "This app needs access to contacts in order to ...", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { _ in
            let url = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    func getEmployeesFromTartu(){
        viewModel.getEmployees(branch: .tartu) { success in
            if success {
                self.employees = self.viewModel.employees
                self.employees.append(contentsOf: self.viewModel.employees)
                self.getEmployeesFromTallinn()
            } else {
                self.showAlert(message: "Task failed successfully")
            }
            self.refreshControl.endRefreshing()
        }
    }
    
    func showLoader() {
        loader = SpinnerView(frame: CGRect(x: view.frame.width / 2 - 50, y: view.frame.height / 2 - 50, width:100, height: 100))
        self.view.addSubview(loader)
    }
    
    func hideLoader() {
        loader.removeFromSuperview()
    }
    
    func getEmployeesFromTallinn(){
        viewModel.getEmployees(branch: .tallinn) { success in
            if success {
                self.employees.append(contentsOf: self.viewModel.employees)
                self.configureTableView()
            } else {
                self.showAlert(message: "Task failed successfully")
            }
            self.refreshControl.endRefreshing()
            self.hideLoader()
        }
    }
    
    func configureTableView(){
        tableView.register(UINib(nibName: EmployeeTVCell.reuseID, bundle: nil), forCellReuseIdentifier: Identifiers.employeeCell)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        removeDuplicates()
        setAllPositions()
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
    
    func setAllPositions(){
        for employe in employees {
            let position = employe.position
            if !employeePositions.contains(position) {
                employeePositions.append(position)
            }
        }
        self.employeePositions.sort(by: { $0.lowercased() < $1.lowercased() })
        self.employees.sort(by: { $0.position.lowercased() < $1.position.lowercased() })
        let sortedEmployees = self.employees.sorted {
            if $0.position == $1.position {
                return $0.lname < $1.lname
            }
            return $0.position < $1.position
        }
        self.employees = sortedEmployees
    }

}


extension ContactsVC: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.filter{ $0.position.contains(employeePositions[section]) }.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.employeeCell, for: indexPath) as! EmployeeTVCell
        var index = indexPath.row
        for i in 0..<indexPath.section { index += self.tableView.numberOfRows(inSection: i) }
        let fullName = "\(employees[index].fname) \(employees[index].lname)"
        let email = employees[index].contact_details?.email
        cell.labelFullName.text = fullName
        cell.labelPosition.text = email
        
        if contactHelper.getContactByName(firstName: employees[index].fname, lastName: employees[index].lname) == nil {
            cell.imagePerson.isHidden = true
        } else {
            cell.imagePerson.isHidden = false
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return employeePositions.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        let label = UILabel()
        label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = employeePositions[section]
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = #colorLiteral(red: 1, green: 0.8092697859, blue: 0, alpha: 1)
        headerView.backgroundColor = #colorLiteral(red: 0.1131135939, green: 0.2060283317, blue: 0.2060283317, alpha: 1)
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        var index = indexPath.row
        for i in 0..<indexPath.section { index += self.tableView.numberOfRows(inSection: i) }
        selectedEmployee = employees[index]
        performSegue(withIdentifier: Identifiers.employeeDetailSegueId, sender: self)
    }

}
