//
//  ImageTableViewCell.swift
//  ImageViewer
//
//  Created by Sahil Kadia on 6/29/18.
//  Copyright © 2018 Sahil Kadia. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var authorname: UILabel!
    @IBOutlet weak var authorurl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
