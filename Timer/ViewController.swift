import UIKit

class ViewController: UIViewController {
   
    private lazy var label: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 50)
        label.textColor = .orange
        label.text = "25:00"
        return label
    }()
    
    private lazy var button: UIButton = {
        var button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(systemName: "play"), for: .normal)
        button.tintColor = .orange
        button.frame = CGRect(x: 120,y: 120,width: 120,height: 120)
        button.frame.size = CGSize(width: 120,height: 120)
        button.imageEdgeInsets = UIEdgeInsets(top: 35, left: 35, bottom: 35, right: 35)
        button.contentEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 40, right: 40);
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var isStarted = false
    private lazy var isWorkTime = false
    private lazy var timer = Timer()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(label)
        view.addSubview(button)
    }
    
    private func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40).isActive = true
    }
    
    private func setupView() {
        view.backgroundColor = .black
    }
    
    // MARK: - Actions
    
    @objc private func buttonAction() {
        if isStarted {
            isStarted = false
            button.setImage(UIImage(systemName: "play"), for: .normal)
            timer.invalidate()
        } else {
            isStarted = true
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
            button.setImage(UIImage(systemName: "pause"), for: .normal)
        }
    }
    
    // Timer body
    @objc private func timerUpdate() {
        let time = label.text?.split(separator: ":")
        var minutes = Int(time?[0] ?? "") ?? 0
        var seconds = Int(time?[1] ?? "") ?? 0
        if seconds > 0 {
            seconds -= 1
        } else {
            if minutes > 0 {
                minutes -= 1
                seconds = 59
            } else {
                changeMode()
                return
            }
        }
        var stringMinutes = String(minutes)
        var stringSeconds = String(seconds)
        if minutes < 10 { stringMinutes = "0" + String(minutes) }
        if seconds < 10 { stringSeconds = "0" + String(seconds) }
        label.text = stringMinutes + ":" + stringSeconds
    }
    
    // Change mode of timer ( working/rest)
    private func changeMode() {
        isStarted = false
        isWorkTime ? (isWorkTime = false) : (isWorkTime = true)
        timer.invalidate()
        if isWorkTime == true {
            label.textColor = .green
            button.tintColor = .green
            button.setImage(UIImage(systemName: "play"), for: .normal)
            label.text = "05:00"
        } else {
            label.textColor = .orange
            button.tintColor = .orange
            button.setImage(UIImage(systemName: "play"), for: .normal)
            label.text = "25:00"
        }
    }

}

