//
//  HomeCell.swift
//  GoJek
//
//  Created by Ram Niwas on 9/6/19.
//  Copyright © 2019 Ramniwas. All rights reserved.
//

import UIKit
import SDWebImage

class HomeCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData(_ dict : HomeModel){
        nameLabel.text = "\(dict.first_name ?? "")" + " " +  "\(dict.last_name ?? "" )"
        
        let imgUrl : URL = URL(string: dict.profile_pic ?? "")!
        imgView!.sd_setImage(with:imgUrl , placeholderImage: #imageLiteral(resourceName: "placeholder_photo"))
        
        favButton.setImage((dict.favorite == true) ? #imageLiteral(resourceName: "favourite_button_selected") :#imageLiteral(resourceName: "favourite_button"), for: .normal)

    }
    
}
