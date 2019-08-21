//
//  ContactViewModel.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class ContactViewModel: ViewModelType {
    
    private let contact: Contact
    private let navigator: ContactNavigator
    
    struct Input {
        let trigger: Driver<Void>
    }
    
    struct Output {
        let contact: Driver<Contact>
    }
    
    init(contact: Contact, navigator: ContactNavigator) {
        self.contact = contact
        self.navigator = navigator
    }
    
    func transform(input: Input) -> Output {
        
        let contact: Driver<Contact> = input.trigger.flatMapLatest { trigger in
            
            return Observable.just(self.contact).asDriverOnErrorJustComplete()
            
        }
        
        return Output(contact: contact)
    }
    
}
