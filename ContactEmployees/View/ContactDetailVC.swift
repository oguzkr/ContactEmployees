//
//  ContactDetailVC.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 10.11.2021.
//

import UIKit
import ContactsUI

class ContactDetailVC: UITableViewController {

    @IBOutlet weak var labelFullName: UILabel!
    @IBOutlet weak var labelPosition: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var labelPhone: UILabel!
    @IBOutlet weak var labelProjects: UILabel!
    @IBOutlet weak var buttonPhone: UIButton!
    
    var employee : Employee?
    var contactViewController:CNContactViewController?
    let contactHelper = ContactHelper()

    override func viewDidLoad() {
        super.viewDidLoad()
        contactHelper.getContacts()
        bindEmployeeData()
    }
    
    
    @IBAction func buttonPhone(_ sender: Any) {
        if let contact = contactHelper.getContactByName(firstName: employee!.fname, lastName: employee!.lname) {
            openContactCard(contact: contact)
        }
    }
    
    fileprivate func openContactCard(contact: CNContact) {
        self.contactViewController=CNContactViewController(for: contact)
        self.contactViewController!.allowsEditing=true
        self.contactViewController!.modalPresentationStyle = .formSheet
        self.contactViewController!.isEditing=false
        self.contactViewController!.delegate=self
        let navigationController = UINavigationController(rootViewController: self.contactViewController!)
        self.present(navigationController, animated: true)
        navigationController.delegate=self
    }

    func bindEmployeeData(){
        if let selectedEmployee = employee {
            
            labelFullName.text = "\(selectedEmployee.fname) \(selectedEmployee.lname)"
            labelPosition.text = selectedEmployee.position
            labelPhone.text = selectedEmployee.contact_details?.phone
            labelEmail.text = selectedEmployee.contact_details?.email
            
            let contact = contactHelper.getContactByName(firstName: selectedEmployee.fname, lastName: selectedEmployee.lname)
            
            if contact == nil {
                buttonPhone.isHidden = true
            } else if selectedEmployee.contact_details?.phone == nil {
                labelPhone.isHidden = true
                buttonPhone.setTitle(contact?.phoneNumbers.first?.value.stringValue, for: .normal)
            } else {
                buttonPhone.setTitle(selectedEmployee.contact_details?.phone, for: .normal)
                buttonPhone.isHidden = false
                labelPhone.isHidden = true
            }

            if let projects = selectedEmployee.projects {
                labelProjects.text = projects.joined(separator: ", ")
            }
        }
    }
    
}

extension ContactDetailVC:CNContactViewControllerDelegate,UINavigationControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
