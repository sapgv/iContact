//
//  ContactsViewController.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift
import Reachability
import RxReachability

class ContactsViewController: UITableViewController {

    var viewModel: ContactsViewModel!
    private let disposeBag = DisposeBag()
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        setupSearchController()
        configureTableView()
        bindUI()
        
    }
    
    private func setupSearchController() {
        // Setup the Search Controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        tableView.refreshControl = UIRefreshControl()
        tableView.estimatedRowHeight = 64
    }

    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func bindUI() {
        
        self.tableView.dataSource = nil

        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .map { _ in
                return ContactsViewModel.Trigger.viewWillAppear(isFiltering: self.isFiltering(), query: self.searchController.searchBar.text ?? "")
            }
            .asDriverOnErrorJustComplete()
        
        let pull = tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver().map { _ in return ContactsViewModel.Trigger.pull }

        let search = searchController.searchBar.rx.text.orEmpty
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { query in ContactsViewModel.Trigger.search(query)}
            .asDriverOnErrorJustComplete()

        let trigger = Driver.merge(viewWillAppear, pull, search)
        
        let input = ContactsViewModel.Input(trigger: trigger, selection: tableView.rx.itemSelected.asDriver())

        Reachability.rx.isDisconnected
            .subscribe(onNext: {
                let alert = Alert()
                alert.alertWith("Network is not available")
            })
            .disposed(by: disposeBag)
        
        //Bind output
        
        let output = viewModel.transform(input: input)
        
        output.contacts.drive(tableView.rx.items(cellIdentifier: "Cell", cellType: ContactCell.self)) { tv, contact, cell in
            cell.bind(contact)
            }.disposed(by: disposeBag)
        
        output.contacts
            .asObservable()
            .subscribe(onNext: { contacts in
                let realm = try! Realm()
                try! realm.write {
                    realm.add(contacts, update: .modified)
                }
        }).disposed(by: disposeBag)
        
        output.fetching
            .drive(tableView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.fetching
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        output.selectedContact
            .drive()
            .disposed(by: disposeBag)
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }

}
