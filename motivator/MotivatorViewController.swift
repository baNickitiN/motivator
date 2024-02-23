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
    
    class userActivity {
        let name: String
        var startDateActivity: Date
        var totalTimeDurationActivity: Int
        var userPurpouse: Int
        
        init(name: String, startDateActivity: Date, totalTimeDurationActivity: Int, userPurpouse: Int) {
            self.name = name
            self.startDateActivity = startDateActivity
            self.totalTimeDurationActivity = totalTimeDurationActivity
            self.userPurpouse = userPurpouse
        }
    }
    
    var userReading = userActivity(name: "Reading", startDateActivity: dateNow, totalTimeDurationActivity: 0, userPurpouse: 15)
    var userMusic = userActivity(name: "Music", startDateActivity: dateNow, totalTimeDurationActivity: 0, userPurpouse: 15)
    var userSport = userActivity(name: "Sport", startDateActivity: dateNow, totalTimeDurationActivity: 0, userPurpouse: 15)
    
    
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
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
        activityLabel.text = userReading.name
        totalTimeLabel.text = String(durationTimer)
        // Do any additional setup after loading the view.
    }
    
    private func disableButtons(){
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    private func enableButtons(){
        startButton.isEnabled = false
        stopButton.isEnabled = true
    }
    
    let animation = CABasicAnimation(keyPath: "backgroundColor")
    
    @IBAction private func touchButtonStart(_ sender: UIButton) {
        enableButtons()
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
        disableButtons()
        timerUse.invalidate()
        hourCountTotal += durationTimer/3600
        totalTimeLabel.text = String(hourCountTotal)
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

