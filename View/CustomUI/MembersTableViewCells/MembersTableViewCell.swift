//
//  MembersTableViewCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/20/21.
//

import UIKit

class MembersTableViewCell: UITableViewCell {
    
    @IBOutlet var memberView : UILabel!
    @IBOutlet var memberAvatarView : UIImageView!
    @IBOutlet var memberGenderView : UILabel!
    @IBOutlet var memberNameView : UILabel!
    @IBOutlet var shadowView : UIView!
    @IBOutlet var memberGenderImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "MembersTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "MembersTableViewCell", bundle: nil)
    }
    
    public func configure( with memberId : String, with memberAvatar : UIImage, with memberNickName : String, with memberGender : String) {
        self.memberView.text = memberNickName
        self.memberView.textColor = .white
        
        self.memberAvatarView.image = memberAvatar
        self.memberAvatarView.layer.cornerRadius = 15
        
        self.shadowView.alpha = 0.8
        
        self.memberGenderView.text = memberGender
        self.memberGenderView.textColor = .white
        
        switch memberGender {
        case "Male":
            self.memberGenderImageView.image = UIImage(named: "defaultPerson")
            self.memberGenderImageView.backgroundColor = UIColor(named: "bgLightBlue")!
            self.shadowView.backgroundColor = UIColor(named: "bgDarkBlue")
        case "Female":
            self.memberGenderImageView.image = UIImage(named: "defaultPerson")
            self.memberGenderImageView.backgroundColor = UIColor(named: "bgLightPurple")!
            self.shadowView.backgroundColor = UIColor(named: "bgDarkPurple")
            self.shadowView.alpha = 1
        default:
            self.memberGenderImageView.image = UIImage(named: "defaultPerson")
            self.memberGenderImageView.backgroundColor = UIColor(named: "bgOrange")!
            self.shadowView.backgroundColor = UIColor(named: "bgLightPink")
        }
        self.memberGenderImageView.layer.cornerRadius = 15
        
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 15
        
        
        
        
        self.shadowView.layer.zPosition = -1
        
    }
    
}
