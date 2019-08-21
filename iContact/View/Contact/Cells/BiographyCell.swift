//
//  BiographyCell.swift
//  iContact
//
//  Created by Grigoriy Sapogov on 21/08/2019.
//  Copyright © 2019 Grigoriy Sapogov. All rights reserved.
//

import UIKit

class BiographyCell: UITableViewCell {

    @IBOutlet weak var biographyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bind(_ contact: Contact) {
        self.biographyLabel.text = contact.biography
    }
    
}
