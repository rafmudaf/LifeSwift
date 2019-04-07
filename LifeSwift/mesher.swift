//
//  mesher.swift
//  MetalCFD
//
//  Created by Rafael M Mudafort on 3/24/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import Foundation

struct mesher {
    static var dx = 1.0
    static var dy = 1.0
    static var xmax = 100.0
    static var ymax = 100.0
    
    static var imax: Int = Int(xmax/dx)
    static var jmax: Int = Int(ymax/dy)
    static var nmax: Int = imax*jmax
}
