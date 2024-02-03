//
//  ViewController.swift
//  motivator
//
//  Created by Boris Nickitin on 17.01.2024.
//

import UIKit
import Foundation

private var dayCount: Int = 0
private var hourCountTotal: Float16 = 0
private var lastDate: String = "18 January 2024"
private var dateNow = Date()
private let calendar = Calendar.current
private let dayNow = calendar.component(.day, from: dateNow)
private let monthNow = calendar.component(.month, from: dateNow)
private let yearNow = calendar.component(.year, from: dateNow)
private let hourNow = calendar.component(.hour, from: dateNow)
private let minuteNow = calendar.component(.minute, from: dateNow)
private let secondNow = calendar.component(.second, from: dateNow)
private var dateFormatter = DateFormatter()
private var convertedDate: String = "0"
private var durationTimer: Float16 = 0


class ViewController: UIViewController {
    

    
    
    @IBOutlet private weak var imageView: UIImageView!
    
    
    private var timerUse =  Timer()
   

    @IBOutlet private weak var timerLabel: UILabel!
    
    @IBOutlet private weak var startButton: UIButton!
    
    @IBOutlet private weak var stopButton: UIButton!
    
    @IBOutlet weak var uiBrainView: UIImageView!
    
    @IBAction private func startButtonDidPress(_ sender: Any) {
        timerUse = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionStart), userInfo: nil, repeats: true)
        }
    
    @objc private func timerActionStart () {
        durationTimer += 1
        UIProgressView.progress += 0.1
        timerLabel.text = "\(Int(durationTimer))"
        print(durationTimer)
         
    }
    
    @IBOutlet private weak var UIBrainBar: UIImageView!
    
    override func viewDidLoad() {
        UIProgressView.progress = 0.0
        UIProgressView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / -2)
        UIProgressView.tintColor = UIColor.ypBackground
        uiBrainView.tintColor = UIColor.ypBackground
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = UIColor.blue.cgColor
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet private weak var UIProgressView: UIProgressView!
    
    
    let animation = CABasicAnimation(keyPath: "backgroundColor")
    
    @IBAction private func touchButtonStart(_ sender: UIButton) {
        uiBrainView.tintColor = UIColor.ypGreen
        dateFormatter.dateFormat = "dd MMMM yyyy"
        convertedDate = dateFormatter.string(from: dateNow)
        animation.fromValue = UIColor.ypGreen.cgColor
        animation.toValue = UIColor.ypBackground.cgColor
        animation.duration = 10.0
        uiBrainView.layer.add(animation, forKey: "backgroundColor")
        if convertedDate == lastDate {
            print("You study for :\(dayCount) days in a row!")
        }
        else {
            dayCount += 1
            print("You study for :\(dayCount) days in a row!")
        }
       durationTimer = 0
       print("convertedDate:\(convertedDate)")
       print("lastDate:\(lastDate)")
       print("dayCount:\(dayCount)")
    }
    
    @IBAction private func stopButtonDidPress(_ sender: Any) {
//        uiBrainView.tintColor = UIColor.ypBackground
        timerUse.invalidate()
        hourCountTotal += durationTimer/3600
        timerLabel.text = "Сейчас ты занимался \(Int(durationTimer)) секунд. Всего \(hourCountTotal) часов!"
        
    }
    
}
