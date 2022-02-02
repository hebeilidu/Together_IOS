//
//  PostDetailTableViewOverViewCell.swift
//  Together
//
//  Created by Bingxin Liu on 11/11/21.
//

import UIKit
import SwiftUI

class PostDetailTableViewOverViewCell: UITableViewCell {
    
    @IBOutlet var titleView : UILabel!
    @IBOutlet var descriptionView : UITextView!
    @IBOutlet var shadowView : UIView!
//    @IBOutlet var descriptionShadowView: UIView!

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
    
    static let identifier = "PostDetailTableViewOverViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewOverViewCell", bundle: nil)
    }
    
    public func configure( with title : String, with description : String, with frameWidth : CGFloat, with frameHeight : CGFloat ) {
        
        self.selectionStyle = .none
        
        self.titleView.text = title
        self.titleView.textColor = .white
        self.descriptionView.text = description
        self.descriptionView.isEditable = false
        self.descriptionView.backgroundColor = .none
        self.descriptionView.textColor = .label
        self.descriptionView.alpha = 1
        self.descriptionView.layer.zPosition = 10
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        self.shadowView.layer.shadowColor = UIColor.gray.cgColor
        self.shadowView.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.shadowView.layer.shadowOpacity = 0.8
        self.shadowView.layer.masksToBounds = false
        self.shadowView.layer.cornerRadius = 10
        self.shadowView.backgroundColor = UIColor(displayP3Red: 193/255, green: 120/255, blue: 213/255, alpha: 1)

//        self.descriptionShadowView.layer.cornerRadius = 10
//        self.descriptionShadowView.clipsToBounds = true
//
//        self.descriptionShadowView.alpha = 0.6
//        self.descriptionShadowView.backgroundColor = UIColor(named: "bgLightBlue")!
        
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: frameWidth - 20, height: self.shadowView.frame.height - 20)
        print("debug?", "\(self.shadowView.frame.width)")
        gradientLayer.colors = [UIColor(named: "bgDarkBlue")!.cgColor, UIColor(named: "bgLightBlue")!.cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.cornerRadius = 10

        self.shadowView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
}
