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
    
    var oldCellArray = Array(repeating: LifeCell(value: 0), count: mesher.n)
    var initCellArray = Array(repeating: LifeCell(value: 0), count: mesher.n)
    let renderer = Renderer(
        xdim: mesher.xdim,
        ydim: mesher.ydim,
        xres: mesher.xres,
        yres: mesher.yres
    )
    @IBOutlet weak var goButton: lifeButton!
    @IBOutlet weak var pauseButton: lifeButton!
    @IBOutlet weak var iterationLabel: lifeButton!
    
    var timer: Timer?
    var iteration: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        pauseButton.isEnabled = false

        for i in 0..<300 {
            initCellArray[(mesher.yres/2)*(mesher.xres/2)+i] = LifeCell(value: 1)
        }
    
        initializeGrid()
    }

    private func initializeGrid() {
        self.iteration = 0
        iterationLabel.setTitle(String(format: "%i", self.iteration), for: .normal)
        oldCellArray = initCellArray
        renderSolution(solution: oldCellArray)
    }

    @IBAction func reset(sender: AnyObject) {
        initializeGrid()
    }
    
    @IBAction func startSolver() {
        goButton.isEnabled = false
        pauseButton.isEnabled = true
        DispatchQueue.global(qos: .userInteractive).sync {
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(
                    timeInterval: 0.1,
                    target: self,
                    selector: #selector(ViewController.runSimulation),
                    userInfo: nil,
                    repeats: true
                )
            }
        }
    }
    
    @objc func runSimulation () {
        let results = solve()
        self.iteration = self.iteration + 1
        if (self.iteration%1 == 0) {
            iterationLabel.setTitle(String(format: "%i", self.iteration), for: .normal)
        }
        DispatchQueue.main.async {
            self.renderSolution(solution: results)
        }
        oldCellArray = results
    }

    @IBAction func pauseSimulation() {
        goButton.isEnabled = true
        pauseButton.isEnabled = false
        DispatchQueue.global(qos: .userInteractive).sync {
            if self.timer != nil {
                self.timer!.invalidate()
                self.timer = nil
            }
        }
    }

    func solve () -> [LifeCell] {
        var newArray = Array(repeating: LifeCell(value: 0), count: mesher.n)
        for i in 0..<oldCellArray.count {
            var count: Int = 0

            let top = Int(i/mesher.xres) == 0
            let right = (i+1)%(mesher.xres) == 0
            let bottom = i/mesher.xres == (mesher.xres-1)
            let left = i%mesher.xres == 0

            if (!top && !right && !bottom && !left) {
                let leftdown = i-mesher.xres-1
                let left = i-1
                let leftup = i+mesher.xres-1
                let up = i+mesher.xres
                let rightup = i+mesher.xres+1
                let right = i+1
                let rightdown = i-mesher.xres+1
                let down = i-mesher.xres

                count += oldCellArray[leftdown].status
                count += oldCellArray[left].status
                count += oldCellArray[leftup].status
                count += oldCellArray[up].status
                count += oldCellArray[rightup].status
                count += oldCellArray[right].status
                count += oldCellArray[rightdown].status
                count += oldCellArray[down].status
            }

            // Any live cell with fewer than two live neighbours dies, as if caused by under-population.
            // cells are initialized dead

            // Any live cell with two or three live neighbours lives on to the next generation.
            if ((count == 2 || count == 3) && oldCellArray[i].isAlive()) {
                newArray[i].status = 1.0
            }

            // Any live cell with more than three live neighbours dies, as if by over-population.
            // cells are initialized dead

            // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
            if (count == 3 && !oldCellArray[i].isAlive()) {
                newArray[i].status = 1.0
            }
        }
        return newArray
    }
    
    func renderSolution(solution: [LifeCell]) {
        self.imageView.image = renderer.render(solution: solution)
    }
}
