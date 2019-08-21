//
//  PhoneCell.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 21/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PhoneCell: UITableViewCell {

    @IBOutlet weak var phoneButton: UIButton!
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ contact: Contact) {
        
        self.phoneButton.setTitle(contact.phone, for: .normal)
        
        phoneButton.rx.tap.subscribe(onNext: { _ in
            
            if let url = URL(string: "tel://\(contact.searchPhone)") {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }).disposed(by: disposeBag)
        
    }
}
