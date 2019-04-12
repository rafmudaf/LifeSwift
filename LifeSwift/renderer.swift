//
//  renderer.swift
//  LifeSwift
//
//  Created by Rafael M Mudafort on 3/24/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import Foundation
import UIKit

class Renderer {
    
    private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    private let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
    private var cellArray: Array<Any>
    var xdim: Int
    var ydim: Int
    var xres: Int
    var yres: Int
    var xCellSize: Int
    var yCellSize: Int
    
    init(xdim: Int, ydim: Int, xres: Int, yres: Int) {
        // the number of pixels in the image
        self.xres = xres
        self.yres = yres

        // the number of cells in the image
        self.xdim = xdim
        self.ydim = ydim

        // the number of pixels per cell
        xCellSize = self.xres / self.xdim
        yCellSize = self.yres / self.ydim
        cellArray = Array(repeating: LifeCell(value: 0), count: self.xdim * self.ydim)

        // create the initial grid
        for n in 0..<self.xdim * self.ydim {
            // using integer division, get the rows and columns before this cell
            var rowsBefore = n / self.xdim
            var columnsBefore = n - rowsBefore * self.xdim
        
            // fill in the cell
            for j in 0..<yCellSize {
                var pixelsBefore = rowsBefore * xdim * yCellSize + columnsBefore * xCellSize + j * xdim;
                for i in 0..<xCellSize {
                    if j==0 || j==yCellSize-1 || i==0 || i==xCellSize-1 {
                        img.pixels[i+pixelsBefore] = color(70,20,70);
                    } else {
                        img.pixels[i+pixelsBefore] = color(255,0,255);
                    }
                }
            }
        }
    }
    
    struct CellData {
        // 4 bytes
        var a: UInt8 = 254
        var r: UInt8
        var g: UInt8
        var b: UInt8
    }
    
    private func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage {
        let bitsPerComponent: Int = 8
        let bitsPerPixel: Int = 32
        
        var data = pixels  // Copy to mutable []
        let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.stride))
        
        let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * MemoryLayout<PixelData>.stride,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: false,
            intent: CGColorRenderingIntent.defaultIntent
        )
        
        return UIImage(cgImage: cgim!);
    }

//    private func fillCell(index: Int, cellArray: [LifeCell]) {
//        var rowsBefore: Int = index / xres;
//        var columnsBefore: Int = index - rowsBefore * xres;
//
//        if cellArray[index].isAlive() {
//            // turn cell off
//            for j in 0..<ypixSize {
//                var pixelsBefore: Int = rowsBefore * xdim * ypixSize + columnsBefore * xpixSize + j * xdim;
//                for i in 0..<xpixSize {
//                    if j==0 || j==ypixSize-1 || i==0 || i==xpixSize-1 {
//                        img.pixels[i+pixelsBefore] = color(30,30,30);
//                    } else {
//                        img.pixels[i+pixelsBefore] = color(0,0,0);
//                    }
//                }
//            }
//            cellArray[index] = LifeCell(value: 0);
//        } else {
//            // turn cell on
//            for j in 0..<ypixSize {
//                var pixelsBefore: Int = rowsBefore * xdim * ypixSize + columnsBefore * xpixSize + j * xdim;
//                for i in 0..<xpixSize {
//                    if j==0 || j==ypixSize-1 || i==0 || i==xpixSize-1 {
//                        img.pixels[i+pixelsBefore] = color(70,20,70);
//                    } else {
//                        img.pixels[i+pixelsBefore] = color(255,0,255);
//                    }
//                }
//            }
//            cellArray[index] = LifeCell(value: 1);
//        }
//    }
    
    func render(solution: [LifeCell]) -> UIImage {
        var pixelArray = Array(repeating: PixelData(a: 255, r:255, g: 0, b: 255), count: solution.count)
        let numCells: Int = solution.count
        
        for i in 0..<numCells
        {
            pixelArray[i].r = UInt8(Double(pixelArray[i].r) * solution[i])
            pixelArray[i].g = UInt8(Double(pixelArray[i].g) * solution[i])
            pixelArray[i].b = UInt8(Double(pixelArray[i].b) * solution[i])
        }
        
        let outputImage = imageFromARGB32Bitmap(pixels: pixelArray, width: mesher.xres, height: mesher.yres)
        return outputImage;
    }
}
