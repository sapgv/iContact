//
//  ContactCell.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 15/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ contact: Contact) {
        self.nameLabel.text = contact.name
        self.phoneLabel.text = contact.phone
        self.temperamentLabel.text = contact.temperament.rawValue
    }
    
}
