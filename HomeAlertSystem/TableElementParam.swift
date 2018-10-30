//
//  TableElementParam.swift
//  HomeAlertSystem
//
//  Created by Ming Yang on 30/10/18.
//  Copyright © 2018 Monash University. All rights reserved.
//

import UIKit

class TableElementParam: NSObject {

    var sectionMark: Int
    var numOfRows: Int
    
    init(sectionMark: Int, numOfRows: Int) {
        self.sectionMark = sectionMark
        self.numOfRows = numOfRows
    }
    
    
}
