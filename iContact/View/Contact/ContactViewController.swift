//
//  ContactViewController.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "Cell"

class ContactViewController: UITableViewController {
    
    var viewModel: ContactViewModel!
    private var contact: Contact!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        
        tableView.register(UINib(nibName: "NameCell", bundle: nil), forCellReuseIdentifier: "NameCell")
        tableView.register(UINib(nibName: "PhoneCell", bundle: nil), forCellReuseIdentifier: "PhoneCell")
        tableView.register(UINib(nibName: "BiographyCell", bundle: nil), forCellReuseIdentifier: "BiographyCell")
        
        tableView.tableFooterView = UIView()
        bindUI()
        
    }

    private func bindUI() {
     
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = ContactViewModel.Input(trigger: viewWillAppear)
        
        let output = viewModel.transform(input: input)
        output.contact.asObservable().subscribe(onNext: { contact in
            self.contact = contact
        }).disposed(by: disposeBag)
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.bind(self.contact)
            return cell
        }
        else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath) as! PhoneCell
            cell.bind(self.contact)
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BiographyCell", for: indexPath) as! BiographyCell
            cell.bind(self.contact)
            return cell
        }

    }
    
}
