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
    @IBOutlet weak var calendarContainerView: UIView!
    private var timerUse =  Timer()
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var startButton: UIButton!
    @IBOutlet private weak var stopButton: UIButton!
    
    // Массив для хранения отмеченных дней
    private var markedDates: Set<String> = []
    
    // Календарь представление
    private var calendarCollectionView: UICollectionView!
    private var monthLabel: UILabel!
    private var weekdaysStackView: UIStackView!
    private var currentDate = Date()
    
    private let prevMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("◀", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    private let nextMonthButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("▶", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        return button
    }()
    
    @IBAction private func startButtonDidPress(_ sender: Any) {
        timerUse = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerActionStart), userInfo: nil, repeats: true)
    }
    
    @objc private func timerActionStart () {
        durationTimer += 1
        timerLabel.text = "\(Int(durationTimer))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadHourCountTotal()
        loadMarkedDates()
        setupUI()
        setupCalendar()
        
        activityLabel.text = userReading.name
        totalTimeLabel.text = String(hourCountTotal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Обновляем frame календаря после layout
        let headerHeight: CGFloat = 50
        let collectionViewHeight = calendarContainerView.bounds.height - headerHeight
        
        monthLabel.frame = CGRect(x: 50, y: 10, width: calendarContainerView.bounds.width - 100, height: 30)
        prevMonthButton.frame = CGRect(x: 10, y: 10, width: 30, height: 30)
        nextMonthButton.frame = CGRect(x: calendarContainerView.bounds.width - 40, y: 10, width: 30, height: 30)
        weekdaysStackView.frame = CGRect(x: 0, y: 40, width: calendarContainerView.bounds.width, height: 20)
        calendarCollectionView.frame = CGRect(x: 0, y: headerHeight,
                                            width: calendarContainerView.bounds.width,
                                            height: collectionViewHeight)
    }
    
    private func setupUI() {
        // Настройка календаря контейнера
        calendarContainerView.layer.cornerRadius = 12
        calendarContainerView.layer.borderWidth = 1
        calendarContainerView.layer.borderColor = UIColor.systemGray4.cgColor
        
        // Настройка кнопок
        startButton.layer.cornerRadius = 8
        stopButton.layer.cornerRadius = 8
        startButton.backgroundColor = .systemBlue
        stopButton.backgroundColor = .systemRed
        startButton.setTitleColor(.white, for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
    }
    
    private func setupCalendar() {
        // Проверяем, что контейнер существует
        guard calendarContainerView != nil else {
            print("❌ calendarContainerView is nil!")
            return
        }
        
        // Инициализируем monthLabel
        monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        monthLabel.textColor = .label
        calendarContainerView.addSubview(monthLabel)
        
        // Добавляем кнопки навигации
        prevMonthButton.addTarget(self, action: #selector(prevMonth), for: .touchUpInside)
        nextMonthButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        
        calendarContainerView.addSubview(prevMonthButton)
        calendarContainerView.addSubview(nextMonthButton)
        
        // Настраиваем дни недели
        weekdaysStackView = UIStackView()
        weekdaysStackView.axis = .horizontal
        weekdaysStackView.distribution = .fillEqually
        
        let weekdays = ["Пн", "Вт", "Ср", "Чт", "Пт", "Сб", "Вс"]
        for weekday in weekdays {
            let label = UILabel()
            label.text = weekday
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            label.textColor = .systemGray
            weekdaysStackView.addArrangedSubview(label)
        }
        
        calendarContainerView.addSubview(weekdaysStackView)
        
        // Настраиваем CollectionView для дней
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calendarCollectionView.backgroundColor = .clear
        calendarCollectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        
        calendarContainerView.addSubview(calendarCollectionView)
        
        // Обновляем календарь
        updateCalendar()
        
        // Отладочная информация
        print("✅ Календарь настроен")
        print("   - calendarContainerView frame: \(calendarContainerView.frame)")
        print("   - calendarCollectionView frame: \(calendarCollectionView.frame)")
    }
    
    private func updateCalendar() {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "MMMM yyyy"
        monthLabel.text = dateFormatter.string(from: currentDate).capitalized
        
        calendarCollectionView.reloadData()
        
        print("📅 Календарь обновлен: \(monthLabel.text ?? "")")
    }
    
    @objc private func prevMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) {
            currentDate = newDate
            updateCalendar()
        }
    }
    
    @objc private func nextMonth() {
        if let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) {
            currentDate = newDate
            updateCalendar()
        }
    }
    
    private func disableButtons(){
        startButton.isEnabled = true
        stopButton.isEnabled = false
    }
    
    private func enableButtons(){
        startButton.isEnabled = false
        stopButton.isEnabled = true
    }
    
    @IBAction private func touchButtonStart(_ sender: UIButton) {
        enableButtons()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        convertedDate = dateFormatter.string(from: Date())
        
        // Отмечаем сегодняшний день в календаре
        markDate(convertedDate)
        
        if convertedDate == lastDate {
            print("You study for :\(dayCount) days in a row!")
        } else {
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
        saveHourCountTotal()
        
        let alert = UIAlertController(
            title: "Ты умничка!",
            message: "Сейчас ты занимался \(Int(durationTimer)) секунд. Всего \(hourCountTotal) часов!",
            preferredStyle: .alert)
        let action = UIAlertAction(title: "ок", style: .default) { _ in
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Работа с отмеченными датами
    
    private func markDate(_ dateString: String) {
        markedDates.insert(dateString)
        saveMarkedDates()
        calendarCollectionView.reloadData()
        print("✅ Дата отмечена: \(dateString)")
    }
    
    private func saveMarkedDates() {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Не удалось получить доступ к директории документов")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("markedDates.txt")
        
        do {
            let datesArray = Array(markedDates)
            let data = try JSONSerialization.data(withJSONObject: datesArray, options: [])
            try data.write(to: fileURL)
            print("✅ Отмеченные даты сохранены: \(markedDates.count) дат")
        } catch {
            print("❌ Ошибка сохранения отмеченных дат: \(error)")
        }
    }
    
    private func loadMarkedDates() {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Не удалось получить доступ к директории документов")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("markedDates.txt")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let data = try Data(contentsOf: fileURL)
                if let datesArray = try JSONSerialization.jsonObject(with: data, options: []) as? [String] {
                    markedDates = Set(datesArray)
                    print("✅ Отмеченные даты загружены: \(markedDates.count) дат")
                }
            } catch {
                print("❌ Ошибка загрузки отмеченных дат: \(error)")
            }
        } else {
            print("ℹ️ Файл с отмеченными датами не найден")
        }
    }
    
    private func getDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func getCalendarDate(for indexPath: IndexPath) -> Date? {
        let calendar = Calendar.current
        let year = calendar.component(.year, from: currentDate)
        let month = calendar.component(.month, from: currentDate)
        
        let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Корректировка для русской локали (понедельник = 2)
        let weekdayOffset = (firstWeekday + 5) % 7 // Правильный расчет offset
        
        let dayOffset = indexPath.item - weekdayOffset + 1
        
        if dayOffset > 0 && dayOffset <= daysInMonth(year: year, month: month) {
            return calendar.date(from: DateComponents(year: year, month: month, day: dayOffset))
        }
        
        return nil
    }
    
    private func daysInMonth(year: Int, month: Int) -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        let date = calendar.date(from: dateComponents)!
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    // MARK: - Сохранение и загрузка hourCountTotal
    
    private func saveHourCountTotal() {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Не удалось получить доступ к директории документов")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("hourCountData.txt")
        
        do {
            let dataString = String(hourCountTotal)
            try dataString.write(to: fileURL, atomically: true, encoding: .utf8)
            print("✅ Данные сохранены: \(hourCountTotal) по пути: \(fileURL.path)")
        } catch {
            print("❌ Ошибка сохранения данных: \(error)")
        }
    }
    
    private func loadHourCountTotal() {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Не удалось получить доступ к директории документов")
            return
        }
        
        let fileURL = documentsDirectory.appendingPathComponent("hourCountData.txt")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                let dataString = try String(contentsOf: fileURL, encoding: .utf8)
                if let loadedValue = Float16(dataString) {
                    hourCountTotal = loadedValue
                    print("✅ Данные загружены: \(hourCountTotal)")
                }
            } catch {
                print("❌ Ошибка загрузки данных: \(error)")
            }
        } else {
            print("ℹ️ Файл с сохраненными данными не найден, используется значение по умолчанию")
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 42 // 6 недель * 7 дней
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as! CalendarDayCell
        
        if let cellDate = getCalendarDate(for: indexPath) {
            let day = Calendar.current.component(.day, from: cellDate)
            cell.dayLabel.text = "\(day)"
            
            let dateString = getDateString(cellDate)
            
            // Проверяем, отмечен ли этот день
            if markedDates.contains(dateString) {
                cell.markAsActive()
            } else {
                cell.markAsInactive()
            }
            
            // Подсвечиваем сегодняшний день
            let todayString = getDateString(Date())
            if dateString == todayString {
                cell.highlightAsToday()
            }
        } else {
            cell.dayLabel.text = ""
            cell.markAsInactive()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 7
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedDate = getCalendarDate(for: indexPath) {
            let dateString = getDateString(selectedDate)
            print("📅 Выбрана дата: \(dateString)")
        }
    }
}

// MARK: - Calendar Day Cell
class CalendarDayCell: UICollectionViewCell {
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = .label
        return label
    }()
    
    private let circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        contentView.addSubview(circleView)
        contentView.addSubview(dayLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        circleView.frame = CGRect(x: (contentView.bounds.width - 30) / 2,
                                 y: (contentView.bounds.height - 30) / 2,
                                 width: 30, height: 30)
        dayLabel.frame = contentView.bounds
    }
    
    func markAsActive() {
        circleView.isHidden = false
        circleView.backgroundColor = .systemBlue.withAlphaComponent(0.3)
        dayLabel.textColor = .systemBlue
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
    
    func markAsInactive() {
        circleView.isHidden = true
        dayLabel.textColor = .label
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    func highlightAsToday() {
        circleView.isHidden = false
        circleView.backgroundColor = .systemGreen.withAlphaComponent(0.3)
        circleView.layer.borderWidth = 1
        circleView.layer.borderColor = UIColor.systemGreen.cgColor
        dayLabel.textColor = .systemGreen
        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
    }
}
