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
    var contacts = [CNContact]()
    var contactViewController:CNContactViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getContacts()
        bindEmployeeData()
    }
    
    
    @IBAction func buttonPhone(_ sender: Any) {
        if let contact = getContacByName(firstName: employee!.fname, lastName: employee!.lname) {
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
    
    func getContacByName(firstName: String, lastName: String) -> CNContact? {
        var result: CNContact?
         for contact in contacts {
             if (!contact.givenName.isEmpty) {
                 if contact.givenName == firstName && contact.familyName == lastName {
                     result = contact
                 }
              }
        }
        return result
    }
    
    
    func getContacts(){
        let contactStore = CNContactStore()
        let keysToFetch: [Any] = [CNContactIdentifierKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactImageDataAvailableKey, CNContactImageDataKey, CNContactViewController.descriptorForRequiredKeys()]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as! [CNKeyDescriptor])
        request.sortOrder = CNContactSortOrder.givenName
            do {
                try contactStore.enumerateContacts(with: request) {
                    (contact, stop) in
                    self.contacts.append(contact)
                }
            }
            catch {
                print("unable to fetch contacts")
        }
    }

    
    func bindEmployeeData(){
        if let selectedEmployee = employee {
            labelFullName.text = "\(selectedEmployee.fname) \(selectedEmployee.lname)"
            
            labelPosition.text = selectedEmployee.position
            labelPhone.text = selectedEmployee.contact_details?.phone
            if selectedEmployee.contact_details?.phone == nil {
                labelPhone.isHidden = true
                buttonPhone.isHidden = true
            } else {
                if getContacByName(firstName: selectedEmployee.fname, lastName: selectedEmployee.lname) == nil {
                    buttonPhone.isHidden = true
                } else {
                    buttonPhone.setTitle(selectedEmployee.contact_details?.phone, for: .normal)
                    buttonPhone.isHidden = false
                    labelPhone.isHidden = true
                }
            }
                
                
            
            labelEmail.text = selectedEmployee.contact_details?.email
            
            if let projects = selectedEmployee.projects {
                labelProjects.text = projects.joined(separator: ", ")
            }
            

        }
    }

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3 && employee?.projects == nil {
            return ""
        }
        return super.tableView(tableView, titleForHeaderInSection: section)
    }
    
}

extension ContactDetailVC:CNContactViewControllerDelegate,UINavigationControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
