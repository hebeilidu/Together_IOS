//
//  PostDetailTableViewDescriptionCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/30/21.
//

import UIKit

class PostDetailTableViewDescriptionCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
