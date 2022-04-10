//
//  TitleTableViewCell.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var favorite: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        favorite.setImage(UIImage(named: ImageNames.favorite.rawValue), for: .normal)
        favorite.setImage(UIImage(named: ImageNames.favoriteFill.rawValue), for: .selected)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
