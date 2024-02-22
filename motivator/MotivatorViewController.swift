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
    
    private var timerUse =  Timer()
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    @IBAction private func startButtonDidPress(_ sender: Any) {
        timerUse = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionStart), userInfo: nil, repeats: true)
    }
    
    @objc private func timerActionStart () {
        durationTimer += 1
        timerLabel.text = "\(Int(durationTimer))"
//        print(durationTimer)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    let animation = CABasicAnimation(keyPath: "backgroundColor")
    
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
        durationTimer = 0
        print("convertedDate:\(convertedDate)")
        print("lastDate:\(lastDate)")
        print("dayCount:\(dayCount)")
    }
    
    @IBAction private func stopButtonDidPress(_ sender: Any) {
        timerUse.invalidate()
        hourCountTotal += durationTimer/3600
        let alert = UIAlertController(
            title: "Ты умничка!",
            message: "Сейчас ты занимался \(Int(durationTimer)) секунд. Всего \(hourCountTotal) часов!",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "ок", style: .default) { _ in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
//    timerLabel.text = "Сейчас ты занимался \(Int(durationTimer)) секунд. Всего \(hourCountTotal) часов!"
    
}

