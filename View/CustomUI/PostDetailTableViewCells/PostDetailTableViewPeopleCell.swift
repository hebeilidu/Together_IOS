//
//  PostDetailTableViewPeopleCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit

class PostDetailTableViewPeopleCell: UITableViewCell {
    
    @IBOutlet var statusView : UILabel!
    @IBOutlet var progressView : UIProgressView!
    @IBOutlet var creatorAvatarView : UIImageView!
    @IBOutlet var shadowView : UIView!
    @IBOutlet var personIcon : UIImageView!
    @IBOutlet var peopleIcon : UIImageView!
    var memberImageViews = [UIImageView]()

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
    
    static let identifier = "PostDetailTableViewPeopleCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewPeopleCell", bundle: nil)
    }
    
    public func configure( with joinedPeopleNum : Int , with maxPeopleNum : Int, with creatorAvator : UIImage, with memberAvatarCache : [String: UIImage?], with members : [String?]?, with owner : String, with frameWidth : CGFloat, with frameHeight : CGFloat) {
        
        self.selectionStyle = .none
        
        self.statusView.text = "\(joinedPeopleNum)/\(maxPeopleNum)"
        self.statusView.textColor = .white
        
        self.progressView.progress = Float(joinedPeopleNum)/Float(maxPeopleNum)
        self.progressView.progressTintColor = .white
        self.progressView.trackTintColor = UIColor(named: "bgLightBlue")!
                
        self.creatorAvatarView.image = creatorAvator
        self.creatorAvatarView.backgroundColor = .white
        self.creatorAvatarView.layer.cornerRadius = 10
        self.creatorAvatarView.clipsToBounds = true
        
        self.personIcon.layer.cornerRadius = 10
        self.personIcon.clipsToBounds = true
        self.personIcon.backgroundColor = .white
        self.personIcon.alpha = 1
        
        self.peopleIcon.layer.cornerRadius = 10
        self.peopleIcon.clipsToBounds = true
        self.peopleIcon.backgroundColor = .white
        self.peopleIcon.alpha = 1
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
//        self.shadowView.clipsToBounds = true
        
        //self.shadowView.layer.zPosition = -1
        
        self.shadowView.backgroundColor = UIColor(named: "bgDarkBlue")!
        self.shadowView.alpha = 0.8
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: frameWidth - 20, height: self.frame.height - 10)
//        gradientLayer.colors = [UIColor(named: "bgDarkBlue")!.cgColor, UIColor.white.cgColor]
//        gradientLayer.locations = [0, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
//        gradientLayer.zPosition = -1
//        gradientLayer.cornerRadius = 10
//
//        self.shadowView.layer.addSublayer(gradientLayer)
        
        
        var membersLeadingPadding : CGFloat = 5.0
        
        for imageView in memberImageViews {
            imageView.removeFromSuperview()
        }
        
        guard let members = members else {return}
        for member in members {
            if member == nil {continue}
            if member! == owner {continue}
            let imageView = UIImageView(
                frame: CGRect(x: self.creatorAvatarView.frame.maxX + membersLeadingPadding,
                              y: self.creatorAvatarView.frame.minY,
                              width: 20,
                              height: 20))
            if memberAvatarCache[member!] != nil {
                imageView.image = memberAvatarCache[member!]!
            } else {
                imageView.image = UIImage(named: "defaultPerson")
            }
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.backgroundColor = .white
            imageView.contentMode = .scaleToFill
            imageView.tag = member!.hashValue
            memberImageViews.append(imageView)
            self.shadowView.addSubview(imageView)
            membersLeadingPadding += 10
            
            if membersLeadingPadding >= self.contentView.frame.width - 200 {break}
        }
    }
    
}
