//
//  NameCell.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 21/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var educationLabel: UILabel!
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
        self.educationLabel.text = "\(contact.educationPeriod.start.short) - \(contact.educationPeriod.end.short)"
        self.temperamentLabel.text = contact.temperament.rawValue
    }

}
