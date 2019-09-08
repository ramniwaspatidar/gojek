//
//  AddContactCell.swift
//  GoJek
//
//  Created by Ram Niwas on 9/7/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit

class AddContactCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureAddInfoCell(dict: InfoStruct, isEdit : Bool) {
        textField.isUserInteractionEnabled = isEdit
        textField.text = dict.value
        //textField.placeholder = dict.placeholder
        titleLabel.text = dict.placeholder
        
        if let type = dict.type{
            switch type {
            case ContactType.first_name, ContactType.last_name :
                textField.keyboardType = .default
            case ContactType.phone_number:
                textField.keyboardType = .phonePad
            case ContactType.email:
                textField.keyboardType = .emailAddress
            }
        }
        
    }

}
