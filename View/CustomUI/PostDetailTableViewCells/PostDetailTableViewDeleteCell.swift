//
//  PostDetailTableViewDeleteCell.swift
//  Together
//
//  Created by Bingxin Liu on 12/2/21.
//

import UIKit

class PostDetailTableViewDeleteCell: UITableViewCell {
    
    @IBOutlet var deleteLabel : UILabel!
    @IBOutlet var shadowView : UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewDeleteCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewDeleteCell", bundle: nil)
    }
    
    public func configure(with frameWidth : CGFloat, with frameHeight : CGFloat) {
        
        self.selectionStyle = .none
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.deleteLabel.layer.cornerRadius = 10
        self.deleteLabel.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
    }
    
}
