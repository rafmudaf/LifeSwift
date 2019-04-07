//
//  renderer.swift
//  LifeSwift
//
//  Created by Rafael M Mudafort on 3/24/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import Foundation
import UIKit

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

private struct PixelData {
    // 4 bytes
    var a: UInt8 = 254
    var r: UInt8
    var g: UInt8
    var b: UInt8
}

private func imageFromARGB32Bitmap(pixels: [PixelData], width: Int, height: Int) -> UIImage {
    let bitsPerComponent: Int = 8
    let bitsPerPixel: Int = 32

    var data = pixels // Copy to mutable []
    let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<PixelData>.size))

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

func render(solution: [Double]) -> UIImage {
    var pixelArray = Array(repeating: PixelData(a: 255, r:255, g: 255, b: 255), count: solution.count)
    let numCells: Int = solution.count
    
    for i in 0..<numCells
    {
        pixelArray[i].r = UInt8(Double(pixelArray[i].r)*solution[i])
        pixelArray[i].g = UInt8(Double(pixelArray[i].g)*solution[i])
        pixelArray[i].b = UInt8(Double(pixelArray[i].b)*solution[i])
    }
    
    let outputImage = imageFromARGB32Bitmap(pixels: pixelArray, width: mesher.imax, height: mesher.jmax)
    
    return outputImage;
}
