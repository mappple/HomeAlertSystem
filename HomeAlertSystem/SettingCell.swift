//
//  SettingCell.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 1/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import UIKit

class SettingCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.white
            nameLabel.textColor = isHighlighted ? UIColor.white : UIColor.black
        }
    }
    
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            if let imageName = setting?.imageName{
                nameImageView.image = UIImage(named: imageName)
            }
            
        }
    }
    
    let nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 40, y: 0, width: 80, height: 40))
        label.text = "Setting"
        label.textColor = UIColor.black
        
        
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    let nameImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "details"))
        return imageView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    func setUpViews(){
        //self.backgroundColor = UIColor.blue
        self.addSubview(self.nameLabel)
        self.addSubview(self.nameImageView)
        //addSubview(nameLabel)
//        let views = ["nameLabel": nameLabel]
//        let formatStringForH = "H:|-[nameLabel]-|"
//        let formatStringForV = "V:|-[nameLabel]-|"
//        let constraintsH = NSLayoutConstraint.constraints(withVisualFormat: formatStringForH, options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
//        let constraintsV = NSLayoutConstraint.constraints(withVisualFormat: formatStringForV, options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
//        NSLayoutConstraint.activate(constraintsH)
//        NSLayoutConstraint.activate(constraintsV)
        
//        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:[view]-(<=0)-[newView(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterY, metrics: nil, views: views)
//        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:[view]-(<=0)-[newView(100)]", options: NSLayoutConstraint.FormatOptions.alignAllCenterX, metrics: nil, views: views)
//        self.addConstraints(horizontalConstraints)
//        self.addConstraints(verticalConstraints)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    
}
