//
//  ContactNavigator.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation
import UIKit

protocol ContactNavigator {
    func toContacts()
}

final class DefaultContactNavigator: ContactNavigator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toContacts() {
        navigationController.popViewController(animated: true)
    }
}
