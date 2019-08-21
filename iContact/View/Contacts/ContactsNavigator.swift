//
//  ContactsNavigator.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation
import UIKit

protocol ContactsNavigator {
    func toContact(_ contact: Contact)
    func toContacts()
}

final class DefaultContactsNavigator: ContactsNavigator {
    
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController,
         storyBoard: UIStoryboard) {
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }
    
    func toContacts() {
        let vc = storyBoard.instantiateViewController(ofType: ContactsViewController.self)
        vc.viewModel = ContactsViewModel(navigator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func toContact(_ contact: Contact) {
        
        let navigator = DefaultContactNavigator(navigationController: navigationController)
        let contactViewModel = ContactViewModel(contact: contact, navigator: navigator)
        let vc = storyBoard.instantiateViewController(ofType: ContactViewController.self)
        vc.viewModel = contactViewModel
        navigationController.pushViewController(vc, animated: true)
        
    }
}
