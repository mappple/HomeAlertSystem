//
//  Visit.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 30/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class Visit: NSObject {

    let id: String
    let time: Date
    let sectionMark: Int
    let url: URL
    let image: UIImage
    
    
    init(id: String, time: Date, sectionMark: Int, url: URL, image: UIImage) {
        self.id = id
        self.time = time
        self.sectionMark = sectionMark
        self.url = url
        self.image = image
        
    }
    
    
}
