//
//  UsersTableViewCell.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import UIKit

class UsersTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel:       UILabel!
    @IBOutlet weak var birthdateLabel:  UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
