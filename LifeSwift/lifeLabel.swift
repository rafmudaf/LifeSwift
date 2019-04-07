//
//  lifeLabel.swift
//  life
//
//  Created by Rafael M Mudafort on 4/1/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import UIKit
import QuartzCore

class lifeLabel: UILabel {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.font = UIFont(name: "Helvetica Nueu", size: 20.0)
        
        self.tintColor = UIColor.blue
        
        self.backgroundColor = UIColor.gray
//        self.layer.borderColor = UIColor.grayColor().CGColor
//        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
    }
}
