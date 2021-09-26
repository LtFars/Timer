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
        button.backgroundColor = nil
        button.imageView?.contentMode = .scaleAspectFit
        button.imageEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        button.contentEdgeInsets = UIEdgeInsets(top: 25, left: 25, bottom: 25, right: 25)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var isStarted = false
    private lazy var isWorkTime = true
    private lazy var animationCreated = false
    private lazy var timer = Timer()
    private let newView = UIView(frame: CGRect(x: 50, y: 40, width: 300, height: 300))
    private let trackLayerAnimation = CABasicAnimation(keyPath: "strokeEnd")
    private lazy var shapeLayerAnimation = CABasicAnimation(keyPath: "strokeEnd")
    private lazy var shapeLayer = CAShapeLayer()
    private lazy var trackLayer = CAShapeLayer()
    
    private lazy var ms = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupHierarchy()
        setupLayout()
        
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(newView)
        newView.addSubview(label)
        newView.addSubview(button)
    }
    
    private func setupLayout() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: newView.topAnchor, constant: 60).isActive = true
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: newView.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 40).isActive = true
    }
    
    private func setupView() {
        view.backgroundColor = .black
        createTrackLayer(color: UIColor.systemPink.cgColor)
    }
    
    // MARK: - Actions
    
    @objc private func buttonAction() {
        if isStarted {
            isStarted = false
            button.setImage(UIImage(systemName: "play"), for: .normal)
            timer.invalidate()
            pauseAnimation(layer: shapeLayer)
        } else {
            isStarted = true
            timer.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
            button.setImage(UIImage(systemName: "pause"), for: .normal)
            resumeAnimation(layer: shapeLayer)
        }
    }
    
    @objc private func timerUpdate() {
        ms += 1
        if ms >= 1000 {
            let time = label.text?.split(separator: ":")
            var minutes = Int(time?[0] ?? "") ?? 0
            var seconds = Int(time?[1] ?? "") ?? 0
            if animationCreated == false {
                createAnimation(color: UIColor.orange.cgColor, time: (minutes * 60 + seconds - 1))
                animationCreated = true
            }
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
            if minutes < 10 { stringMinutes = "0" + stringMinutes }
            if seconds < 10 { stringSeconds = "0" + stringSeconds }
            label.text = stringMinutes + ":" + stringSeconds
            ms = 0
        }
    }
    
    private func changeMode() {
        if isWorkTime {
            isWorkTime = false
            label.textColor = .green
            button.tintColor = .green
            label.text = "05:00"
            createTrackLayer(color: UIColor.systemPink.cgColor)
            let time = label.text?.split(separator: ":")
            let minutes = Int(time?[0] ?? "") ?? 0
            let seconds = Int(time?[1] ?? "") ?? 0
            createAnimation(color: UIColor.green.cgColor, time: (minutes * 60 + seconds))
            
        } else {
            isWorkTime = true
            label.textColor = .orange
            button.tintColor = .orange
            label.text = "25:00"
            createTrackLayer(color: UIColor.systemPink.cgColor)
            let time = label.text?.split(separator: ":")
            let minutes = Int(time?[0] ?? "") ?? 0
            let seconds = Int(time?[1] ?? "") ?? 0
            createAnimation(color: UIColor.orange.cgColor, time: (minutes * 60 + seconds))
        }
    }
    
    // MARK: - Animations
    private func createAnimation(color: CGColor, time: Int) {
        var center = newView.center
        center.x -= 50
        center.y -= 40
        let startAngle: CGFloat = -0.25 * 2 * .pi
        let endAngle: CGFloat = startAngle + 2 * .pi
        let circularPath = UIBezierPath(arcCenter: center, radius: 130, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 5
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineCap = CAShapeLayerLineCap.round
        shapeLayer.strokeEnd = 0
        shapeLayer.path = circularPath.cgPath
        newView.layer.addSublayer(shapeLayer)
        shapeLayerAnimation.toValue = 1
        shapeLayerAnimation.duration = CFTimeInterval(time)
        shapeLayerAnimation.speed = 1
        shapeLayerAnimation.fillMode = CAMediaTimingFillMode.forwards
        shapeLayerAnimation.isRemovedOnCompletion = false
        shapeLayer.add(shapeLayerAnimation, forKey: "shapeLayer")
    }
    
    private func pauseAnimation(layer : CAShapeLayer){
        let pausedTime : CFTimeInterval = layer.convertTime(CACurrentMediaTime(), from: nil)
        layer.speed = 0.0
        layer.timeOffset = pausedTime
    }
    
    private func resumeAnimation(layer : CAShapeLayer){
        let pausedTime = layer.timeOffset
        layer.speed = 1.0
        layer.timeOffset = 0.0
        layer.beginTime = 0.0
        let timeSincePause = layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        layer.beginTime = timeSincePause
    }
    
    private func createTrackLayer(color: CGColor) {
        var center = newView.center
        center.x -= 50
        center.y -= 40
        let circularPath = UIBezierPath(arcCenter: center, radius: 130, startAngle: -CGFloat.pi / 2, endAngle: 2 * CGFloat.pi, clockwise: true)
        trackLayer.strokeColor = color
        trackLayer.lineWidth = 5
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineCap = CAShapeLayerLineCap.round
        trackLayer.strokeEnd = 0
        trackLayer.path = circularPath.cgPath
        newView.layer.addSublayer(trackLayer)
        trackLayerAnimation.toValue = 100
        trackLayerAnimation.duration = 0
        trackLayerAnimation.fillMode = CAMediaTimingFillMode.forwards
        trackLayerAnimation.isRemovedOnCompletion = false
        trackLayer.add(trackLayerAnimation, forKey: "trackLayer")
    }
}
