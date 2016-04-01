//
//  ViewController.swift
//  life
//
//  Created by Rafael M Mudafort on 3/31/16.
//  Copyright © 2016 Rafael M Mudafort. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
//    @IBOutlet weak var startButton: UIButton!
    
    var oldArray: [Double] = [Double](count: mesher.nmax, repeatedValue: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oldArray[3] = 1.0
        
        oldArray[mesher.imax + 3] = 1.0
        oldArray[mesher.imax + 4] = 1.0
        oldArray[mesher.imax + 5] = 1.0
        oldArray[2*mesher.imax + 3] = 1.0
        oldArray[4*mesher.imax + 3] = 1.0
        oldArray[5*mesher.imax + 3] = 1.0
        oldArray[6*mesher.imax + 3] = 1.0
        oldArray[mesher.imax + 2] = 1.0
        renderSolution(oldArray)
    }
    
    @IBAction func startSolver() {
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(ViewController.solve), userInfo: nil, repeats: true)
    }
    
    func solve () {
            var newArray: [Double] = [Double](count: mesher.nmax, repeatedValue: 0.0)

            for i in 0..<oldArray.count {
                var count: Double = 0

                let top = Int(i/mesher.imax) == 0
                let right = (i+1)%(mesher.imax) == 0
                let bottom = i/mesher.imax == (mesher.imax-1)
                let left = i%mesher.imax == 0
                
                if (!top && !right && !bottom && !left) {
                    let leftdown = i-mesher.imax-1
                    let left = i-1
                    let leftup = i+mesher.imax-1
                    let up = i+mesher.imax
                    let rightup = i+mesher.imax+1
                    let right = i+1
                    let rightdown = i-mesher.imax+1
                    let down = i-mesher.imax
                    
                    count += oldArray[leftdown]
                    count += oldArray[left]
                    count += oldArray[leftup]
                    count += oldArray[up]
                    count += oldArray[rightup]
                    count += oldArray[right]
                    count += oldArray[rightdown]
                    count += oldArray[down]
                }
                
                
                if count == 3 || count == 2 {
                    newArray[i] = 1.0
                }
                if count < 2 || count > 3{
                    newArray[i] = 0.0
                }
            }
            
            renderSolution(newArray)
            oldArray = newArray
        
    }
    
    func renderSolution(solution: [Double]) {
        self.imageView.image = render(solution)
        
    }
}