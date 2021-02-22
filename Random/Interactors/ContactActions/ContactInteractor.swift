//
//  ContactInteractor.swift
//  Random Pro
//
//  Created by Vitalii Sosin on 22.02.2021.
//  Copyright © 2021 Sosin.bet. All rights reserved.
//

import Combine
import SwiftUI
import Contacts

protocol ContactInteractor {
    func generateContacts(state: Binding<AppState.AppData>)
    func cleanContacts(state: Binding<AppState.AppData>)
    func saveContactToUserDefaults(state: Binding<AppState.AppData>)
}

struct ContactInteractorImpl: ContactInteractor {
    
    func saveContactToUserDefaults(state: Binding<AppState.AppData>) {
        DispatchQueue.main.async {
            saveContacts(state: state)
            saveResultFullName(state: state)
            saveResultPhone(state: state)
        }
    }
    
    func generateContacts(state: Binding<AppState.AppData>) {
        let contacts = shuffledContacts()
        guard let firstContact = contacts.first else { return }
        let fullName = "\(firstContact.lastName) \(firstContact.firstName)"
        let phone = "\(firstContact.telephone)"
        
        state.contact.listResults.wrappedValue.append(firstContact)
        state.contact.resultPhone.wrappedValue = phone
        state.contact.resultFullName.wrappedValue = fullName
    }
    
    func cleanContacts(state: Binding<AppState.AppData>) {
        state.contact.listResults.wrappedValue = []
        state.contact.resultPhone.wrappedValue = ""
        state.contact.resultFullName.wrappedValue = ""
    }
}

extension ContactInteractorImpl {
    
    private func fetchContacts() -> [FetchedContacts] {
        var contacts = [FetchedContacts]()
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        contacts.append(FetchedContacts(firstName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
        return contacts
    }
    
        private func shuffledContacts() -> [FetchedContacts] {
            return fetchContacts().shuffled()
        }
    
}

// MARK - Contacts Save
extension ContactInteractorImpl {
    private func encoder(contacts: [FetchedContacts], forKey: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(contacts) {
            UserDefaults.standard.set(encoded, forKey: forKey)
        }
    }
}

extension ContactInteractorImpl {
    private func saveContacts(state: Binding<AppState.AppData>) {
        encoder(contacts: state.contact.listResults.wrappedValue,
                forKey: "ContactListResult")
    }
    
    private func saveResultFullName(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.contact.resultFullName.wrappedValue,
                                  forKey: "ContactResultFullName")
    }
    
    private func saveResultPhone(state: Binding<AppState.AppData>) {
        UserDefaults.standard.set(state.contact.resultPhone.wrappedValue,
                                  forKey: "ContactResultPhone")
    }
}
