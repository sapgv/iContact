//
//  ViewModel.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 14/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import RxRealm

final class ContactsViewModel: ViewModelType {
    
    enum Trigger {
        case viewWillAppear(isFiltering: Bool, query: String)
        case pull
        case search(String)
    }
    
    struct Input {
        let trigger: Driver<Trigger>
        let selection: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let contacts: Driver<[Contact]>
        let selectedContact: Driver<Contact>
    }
    
    private let navigator: ContactsNavigator
    
    init(navigator: ContactsNavigator) {
        self.navigator = navigator
    }
    
    private func contacts(_ int: Int) -> Observable<[Contact]> {
        let urlRequest = URLRequest(url: URL(string: "https://raw.githubusercontent.com/SkbkonturMobile/mobile-test-ios/master/json/generated-0\(int).json")!)
        return URLSession.shared.rx.response(request: urlRequest)
            .map { _, data -> [Contact] in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let contacts = try decoder.decode([Contact].self, from: data)
                return contacts
        }
    }

    private var needToUpdate: Bool {
        let lastUpdated = UserDefaults.standard.object(forKey: "lastUpdated")
        if let lastUpdated = lastUpdated as? Date {
            return Date().timeIntervalSince(lastUpdated) > 60 ? true : false
        }
        return true
    }
    
    private func fetch(_ forcedUpdate: Bool = false) -> Observable<[Contact]> {
        let factory: Observable<[Contact]> = Observable.deferred {
            return self.needToUpdate || forcedUpdate ? self.fetchContacts() : self.realmContacts()
            }.map({ (contacts) -> [Contact] in
                return contacts.sorted(by: { (contact1, contact2) -> Bool in
                    return contact1.name < contact2.name
                })
            })
        return factory
        
    }
    
    private func fetchContacts() -> Observable<[Contact]> {
        
        let c1 = contacts(1)
        let c2 = contacts(2)
        let c3 = contacts(3)

        let zipped = Observable.zip(c1, c2, c3) { c1, c2, c3 -> [Contact] in
            return c1 + c2 + c3
            }.do(onNext: { contacts in
                UserDefaults.standard.set(Date(), forKey: "lastUpdated")
            })
    
        return zipped
        
    }
    
    private func realmContacts() -> Observable<[Contact]> {
        
        let realm = try! Realm()
        let contacts = realm.objects(Contact.self)
        
        return Observable.of(Array(contacts))
        
    }
    
    private func search(_ query: String) -> Observable<[Contact]> {
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "name CONTAINS [c] %@ OR searchPhone CONTAINS %@", query, query)
        let contacts = Array(realm.objects(Contact.self).filter(predicate))
        
        return Observable.of(contacts)
        
    }
    
    func transform(input: Input) -> Output {

        let activityIndicator = ActivityIndicator()

        let contacts: Driver<[Contact]> = input.trigger.flatMapLatest { trigger in
            
            switch trigger {
            case .viewWillAppear(let isFiltering, let query):
                if isFiltering {
                    return self.search(query)
                        .asDriverOnErrorJustComplete()
                }
                return self.fetch()
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            case .pull:
                return self.fetch(true)
                    .trackActivity(activityIndicator)
                    .asDriverOnErrorJustComplete()
            case .search(let query):
                if query.isEmpty {
                    return self.realmContacts()
                        .asDriverOnErrorJustComplete()
                }
                return self.search(query)
                    .asDriverOnErrorJustComplete()
            }
            
        }
        
        let fetching = activityIndicator.asDriver()
        
        let selectedContact = input.selection
            .withLatestFrom(contacts) { (indexPath, contacts) -> Contact in
                return contacts[indexPath.row]
            }
            .do(onNext: navigator.toContact)
        
        return Output(fetching: fetching, contacts: contacts, selectedContact: selectedContact)

    }
    
}
