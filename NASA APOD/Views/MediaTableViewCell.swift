//
//  MediaTableViewCell.swift
//  NASA APOD
//
//  Created by Ram Voleti on 10/04/22.
//

import UIKit
import youtube_ios_player_helper

class MediaTableViewCell: UITableViewCell {

    @IBOutlet weak var videoView: YTPlayerView!
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
