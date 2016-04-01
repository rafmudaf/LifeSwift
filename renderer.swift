//
//  renderer.swift
//  MetalCFD
//
//  Created by Rafael M Mudafort on 3/24/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import Foundation
import UIKit

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedFirst.rawValue)

private func imageFromARGB32Bitmap(pixels:[PixelData], width:Int, height:Int)->UIImage
{
    let bitsPerComponent:Int = 8
    let bitsPerPixel:Int = 32
    
    var data = pixels // Copy to mutable []
    let providerRef = CGDataProviderCreateWithCFData(NSData(bytes: &data, length: data.count * sizeof(PixelData)))
    
    let cgim = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, width * Int(sizeof(PixelData)), rgbColorSpace,	bitmapInfo, providerRef, nil, false, CGColorRenderingIntent.RenderingIntentDefault)
    
    return UIImage(CGImage: cgim!);
}

func render(solution : [Double]) -> UIImage
{
    var pixelArray = [PixelData](count: solution.count, repeatedValue: PixelData(a: 255, r:255, g: 255, b: 255));
    let numCells: Int = solution.count
    
    for i in 0..<numCells
    {
        pixelArray[i].r = UInt8(Double(pixelArray[i].r)*solution[i])
        pixelArray[i].g = UInt8(Double(pixelArray[i].g)*solution[i])
        pixelArray[i].b = UInt8(Double(pixelArray[i].b)*solution[i])
    }
    
    let outputImage = imageFromARGB32Bitmap(pixelArray, width: mesher.imax, height: mesher.jmax)
    
    return outputImage;
}

private func exp(a: Int, _ b: Double) -> Double {
    return pow(Double(a),Double(b))
}

private func nonZeroMin(array: [Double]) -> Double {
    let len: Int  = array.count
    var min: Double = array.maxElement()!
    
    for i in 0..<len {
        if array[i] < min && array[i] > 0 {
            min = array[i]
        }
    }
    return min
}

struct PixelData
{
    var a:UInt8 = 254
    var r:UInt8
    var g:UInt8
    var b:UInt8
}