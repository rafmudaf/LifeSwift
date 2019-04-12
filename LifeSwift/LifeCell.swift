//
//  LifeCell.swift
//  LifeSwift
//
//  Created by Mudafort, Rafael on 4/11/19.
//  Copyright © 2019 Mudafort, Rafael. All rights reserved.
//

import Foundation

class LifeCell {
    
    var status: Int
    
    init(value: Int) {
        status = value
    }
    
    func isAlive() -> Bool {
        return self.status == 1
    }
}
