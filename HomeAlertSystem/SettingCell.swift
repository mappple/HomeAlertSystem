//
//  SettingCell.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 1/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import Foundation
import UIKit

/*
 The class is to provide setting items' cell in the drop down setting menu collection view
 */
class SettingCell: UICollectionViewCell {
    
    /*
     The attribute to set the highlight style when the cell is tapped
     */
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? UIColor.darkGray : UIColor.black
            nameLabel.textColor = isHighlighted ? UIColor.black : UIColor.white
        }
    }
    
    /*
     The attribute to set setting items' needed information
     */
    var setting: Setting? {
        didSet {
            nameLabel.text = setting?.name
            //if let imageName = setting?.imageName{
            //    nameImageView.image = UIImage(named: imageName)
            //}
            
        }
    }
    
    /*
     The label to be presented in the setting item cell
     */
    let nameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 120, height: 40))
        label.text = "Setting"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Zapfino", size: 12)
        
        
        label.textAlignment = .center
        label.lineBreakMode = .byClipping
        label.numberOfLines = 0
        return label
    }()
    
    /*
     The image to be presented in the setting item cell
     */
    let nameImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "details"))
        return imageView
    }()
    
    
    /*
     Initialization for the setting item cell
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    /*
     To set the view of the setting item cell
     */
    func setUpViews(){
        //self.backgroundColor = UIColor.blue
        self.addSubview(self.nameLabel)
        //self.addSubview(self.nameImageView)
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
    
    /*
     Initialization for the setting item cell
     */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    
}
