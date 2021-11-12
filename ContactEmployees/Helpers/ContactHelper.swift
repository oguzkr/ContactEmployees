//
//  ContactHelper.swift
//  ContactEmployees
//
//  Created by Oğuz Karatoruk on 12.11.2021.
//

import UIKit
import ContactsUI

class ContactHelper {
    
    var contacts = [CNContact]()
    
    func getContactByName(firstName: String, lastName: String) -> CNContact? {
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

    
}
