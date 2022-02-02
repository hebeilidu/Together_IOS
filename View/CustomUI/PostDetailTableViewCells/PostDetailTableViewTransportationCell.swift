//
//  PostDetailTableViewTransportationCell.swift
//  Together
//
//  Created by Bingxin Liu on 12/2/21.
//

import UIKit

class PostDetailTableViewTransportationCell: UITableViewCell {
    
    @IBOutlet var transportationImage : UIImageView!
    @IBOutlet var transportationLabel : UILabel!
    @IBOutlet var shadowView : UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.transportationImage.layer.cornerRadius = self.transportationImage.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static let identifier = "PostDetailTableViewTransportationCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "PostDetailTableViewTransportationCell", bundle: nil)
    }
    
    public func configure( with transportationType: Transportation, with frameWidth : CGFloat, with frameHeight : CGFloat ) {
        
        self.selectionStyle = .none
        
        switch transportationType {
        case .car:
            self.transportationImage.image = UIImage(named: "car")
            self.transportationLabel.text = "car"
        case .walk:
            self.transportationImage.image = UIImage(named: "walk")
            self.transportationLabel.text = "walk"
        case .tram:
            self.transportationImage.image = UIImage(named: "metro")
            self.transportationLabel.text = "metro"
        case .bike:
            self.transportationImage.image = UIImage(named: "bicycle")
            self.transportationLabel.text = "bicycle"
        case .taxi:
            self.transportationImage.image = UIImage(named: "taxi")
            self.transportationLabel.text = "taxi"
        }
        
        self.transportationLabel.textColor = .white
        
        self.transportationImage.layer.cornerRadius = 15
        self.transportationImage.clipsToBounds = true
        self.transportationImage.backgroundColor = .white
        self.transportationImage.alpha = 1
        
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
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: frameWidth - 20, height: 40)
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
