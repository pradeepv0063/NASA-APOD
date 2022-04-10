//
//  DetailTableViewCell.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var detail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
