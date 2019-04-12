//
//  mesher.swift
//  LifeSwift
//
//  Created by Rafael M Mudafort on 3/24/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import Foundation

struct mesher {
    static var xdim = 500
    static var ydim = 500
    static var xres_max = 50
    static var yres_max = 50
    static var xres = 25
    static var yres = 25
    static var n = xres * yres
    var xpixSize = xdim/xres;
    var ypixSize = ydim/yres;
}
