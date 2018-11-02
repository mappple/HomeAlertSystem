//
//  SignTextField.swift
//  HomeAlertSystem
//
//  Created by Mappple on 2/11/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class SignTextField: UITextField {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureUI()
    }
    
    private func configureUI() {
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 4.0
    }

}
