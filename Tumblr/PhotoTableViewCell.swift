//
//  PhotoTableViewCell.swift
//  Tumblr
//
//  Created by Jesus perez on 2/1/18.
//  Copyright © 2018 Jesus perez. All rights reserved.
//

import UIKit


class PhotoTableViewCell: UITableViewCell {

    
    @IBOutlet weak var photo: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
