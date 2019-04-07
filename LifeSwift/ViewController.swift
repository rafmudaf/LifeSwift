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
    
    var oldArray = Array(repeating: 0.0, count: mesher.nmax)
    var initArray = Array(repeating: 0.0, count: mesher.nmax)
    @IBOutlet weak var iterationLabel: lifeButton!
    
    var iteration: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        iterationLabel.setTitle("0", for: .normal)

        for i in 0..<300 {
            initArray[(mesher.jmax/2)*(mesher.imax/2)+i] = 1.0
        }
//        initArray[(mesher.jmax/2)*(mesher.imax/2)+mesher.imax/2] = 0.0
//        initArray[(mesher.jmax/2)*(mesher.imax/2)+1+mesher.imax/2] = 0.0
//        initArray[(mesher.jmax/2)*(mesher.imax/2)-1-mesher.imax/2] = 0.0
//        initArray[(mesher.jmax/2)*(mesher.imax/2)-1+mesher.imax/2] = 0.0
//        initArray[(mesher.jmax/2)*(mesher.imax/2)-mesher.imax/2] = 0.0
//        initArray[(mesher.jmax/2)*(mesher.imax/2)+mesher.imax+mesher.imax/2] = 0.0

        oldArray = initArray
        renderSolution(solution: oldArray)
    }
    
    @IBAction func reset(sender: AnyObject) {
        oldArray = initArray
        self.iteration = 0
    }
    
    @IBAction func startSolver() {
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(ViewController.runSimulation), userInfo: nil, repeats: true)
    }
    
    @objc func runSimulation () {

        let results = solve()

        self.iteration = self.iteration + 1

        if (self.iteration%1 == 0) {
            iterationLabel.setTitle(String(format: "%i", self.iteration), for: .normal)
        }

        renderSolution(solution: results)

        oldArray = results
    }
        
    @objc func solve () -> [Double] {
        var newArray = Array(repeating: 0.0, count: mesher.nmax)
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

            // Any live cell with fewer than two live neighbours dies, as if caused by under-population.
            // cells are initialized dead

            // Any live cell with two or three live neighbours lives on to the next generation.
            if ((count == 2 || count == 3) && oldArray[i] == 1.0) {
                newArray[i] = 1.0
            }

            // Any live cell with more than three live neighbours dies, as if by over-population.
            // cells are initialized dead

            // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            if (count == 3 && oldArray[i] == 0.0) {
                newArray[i] = 1.0
            }
        }
        return newArray
    }
    
    func renderSolution(solution: [Double]) {
        self.imageView.image = render(solution: solution)
    }
}
