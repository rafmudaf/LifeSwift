//
//  lifeButton.swift
//  life
//
//  Created by Rafael M Mudafort on 4/1/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import UIKit

class lifeButton: UIButton {

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.titleLabel!.font = UIFont(name: "Helvetica Nueu", size: 20.0)
        
        self.sizeThatFits(CGSize(width: CGFloat(100.0), height: (100.0)))
        
        self.tintColor = UIColor.blue
        self.backgroundColor = UIColor.gray
//        self.layer.borderColor = UIColor.grayColor().CGColor
//        self.layer.borderWidth = 2
        self.layer.cornerRadius = 4
    }
}
