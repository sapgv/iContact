//
//  Application.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation
import UIKit

final class Application {
    
    static let shared = Application()
    
    private init() {
    }
    
    func configureMainInterface(in window: UIWindow) {

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactsNavigationController = UINavigationController()

        let contactsNavigator = DefaultContactsNavigator(navigationController: contactsNavigationController,
                                                     storyBoard: storyboard)
        
        window.rootViewController = contactsNavigationController
        
        contactsNavigator.toContacts()
        
    }
}
