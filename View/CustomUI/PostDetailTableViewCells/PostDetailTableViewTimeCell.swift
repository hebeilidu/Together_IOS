//
//  PostDetailTableViewTimeCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit

class PostDetailTableViewTimeCell: UITableViewCell {
    
    @IBOutlet var departureTime : UILabel!
    @IBOutlet var shadowView : UIView!
    @IBOutlet var timeIcon : UIImageView!

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
    
    static let identifier = "PostDetailTableViewTimeCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewTimeCell", bundle: nil)
    }
    
    public func configure( with time : String, with frameWidth : CGFloat, with frameHeight : CGFloat) {
        
        self.selectionStyle = .none
        
        self.departureTime.text = time
        self.departureTime.textColor = .white
        
        self.timeIcon.layer.cornerRadius = 15
        self.timeIcon.clipsToBounds = true
        self.timeIcon.backgroundColor = .white
        self.timeIcon.alpha = 1
        
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
                
        self.shadowView.layer.zPosition = -1
        
        self.shadowView.backgroundColor = UIColor(named: "bgDarkBlue")!
        self.shadowView.alpha = 0.8
        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: frameWidth - 20, height: self.shadowView.bounds.height - 5)
//        gradientLayer.colors = [UIColor(named: "bgDarkBlue")!.cgColor, UIColor(named: "bgLightBlue")!.cgColor]
//        gradientLayer.locations = [0, 1]
//        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//        gradientLayer.zPosition = -1
//        gradientLayer.cornerRadius = 10
//
//        self.shadowView.layer.addSublayer(gradientLayer)
    }
    
}
