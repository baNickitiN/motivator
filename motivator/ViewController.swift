//
//  ViewController.swift
//  motivator
//
//  Created by Boris Nickitin on 17.01.2024.
//

import UIKit
import Foundation

private var dayCount: Int = 0
private var hourCountTotal: Double = 0
private var lastDate: String = "18 January 2024"
private var dateNow = Date()
private let calendar = Calendar.current
private let dayNow = calendar.component(.day, from: dateNow)
private let monthNow = calendar.component(.month, from: dateNow)
private let yearNow = calendar.component(.year, from: dateNow)
private let hourNow = calendar.component(.hour, from: dateNow)
private let minuteNow = calendar.component(.minute, from: dateNow)
private let secondNow = calendar.component(.second, from: dateNow)
var dateFormatter = DateFormatter()
var convertedDate: String = "0"
var durationTimer: Float16 = 0

class ViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    
    var timerUse =  Timer()
   

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func startButtonDidPress(_ sender: Any) {
        timerUse = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionStart), userInfo: nil, repeats: true)
    }
    
    @objc func timerActionStart () {
        durationTimer += 1
        timerLabel.text = "\(Int(durationTimer))"
        print(durationTimer)
         
    }
    
    @IBAction func stopButtonDidPress(_ sender: Any) {
        timerUse.invalidate()
        timerLabel.text = "Ты занимался \(Int(durationTimer)) секунд. Это \((durationTimer)/3600) часа!"
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = UIImage.brainUi
        // Do any additional setup after loading the view.
    }

    @IBAction private func touchButtonStart(_ sender: UIButton) {
        dateFormatter.dateFormat = "dd MMMM yyyy"
        convertedDate = dateFormatter.string(from: dateNow)
        if convertedDate == lastDate {
            print("You study for :\(dayCount) days in a row!")
        }
        else {
            dayCount += 1
            print("You study for :\(dayCount) days in a row!")
        }
        
       print("convertedDate:\(convertedDate)")
       print("lastDate:\(lastDate)")
       print("dayCount:\(dayCount)")
    }
    
}
