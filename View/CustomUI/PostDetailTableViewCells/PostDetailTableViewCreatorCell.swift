//
//  PostDetailTableViewCreatorCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/30/21.
//

import UIKit

class PostDetailTableViewCreatorCell: UITableViewCell {
    
    @IBOutlet var userAvatarView: UIImageView!
    @IBOutlet var creatorLabel: UILabel!
    @IBOutlet var shadowView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userAvatarView.layer.cornerRadius = userAvatarView.frame.width/2
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewCreatorCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewCreatorCell", bundle: nil)
    }
    
    public func configure( with creatorAvatar : UIImage, with creatorName : String, with frameWidth : CGFloat, with frameHeight : CGFloat) {
        self.userAvatarView.image = creatorAvatar
        self.creatorLabel.text = creatorName
        
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
        
        self.shadowView.layer.zPosition = -1
        
        self.shadowView.backgroundColor = UIColor(named: "bgGreen")
        
    }
    
}
