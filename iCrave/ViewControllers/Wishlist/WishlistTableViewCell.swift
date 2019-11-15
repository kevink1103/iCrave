//
//  WishlistTableViewCell.swift
//  iCrave
//
//  Created by Kevin Kim on 15/11/2019.
//  Copyright © 2019 Kevin Kim. All rights reserved.
//

import UIKit
import Cards

class WishlistTableViewCell: UITableViewCell {

    @IBOutlet var cardView: CardHighlight!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
