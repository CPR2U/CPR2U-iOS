//
//  DispatchTimerView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/31.
//

import Combine
import UIKit

class DispatchTimerView: UIView {

    private let calledTime: Date?
    
    private let timeImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "time.png")
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 16)
        label.textAlignment = .left
        label.textColor = .mainRed
        label.text = "elapsed_time_txt".localized()
        return label
    }()
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 48)
        label.textColor = .mainRed
        label.textAlignment = .center
        label.text = "00:00"
        return label
    }()
    
    private var timer: Timer.TimerPublisher?
    private var cancellables = Set<AnyCancellable>()

    init(calledTime: Date) {
        self.calledTime = calledTime
        super.init(frame: CGRect.zero)
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {

        let timeLabelStackView = UIStackView(arrangedSubviews: [
            timeImageView,
            descriptionLabel
        ])
        
        timeLabelStackView.axis  = NSLayoutConstraint.Axis.horizontal
        timeLabelStackView.alignment = UIStackView.Alignment.center
        
        timeLabelStackView.spacing   = 4
        
        NSLayoutConstraint.activate([
            timeImageView.widthAnchor.constraint(equalToConstant: 16),
            timeImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        descriptionLabel.sizeToFit()
        
        let timeStackView = UIStackView()
        timeStackView.axis  = NSLayoutConstraint.Axis.vertical
        timeStackView.alignment = UIStackView.Alignment.center
        timeStackView.spacing   = 8
        self.addSubview(timeStackView)
        timeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            timeLabelStackView,
            timeLabel
        ].forEach({
            timeStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 182),
            timeLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            timeStackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeStackView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            timeLabelStackView.centerXAnchor.constraint(equalTo: timeStackView.centerXAnchor),
            timeLabelStackView.heightAnchor.constraint(equalToConstant: 24)
        ])
        timeLabelStackView.sizeToFit()
        
    }
    
    private func setUpStyle() {
        backgroundColor = UIColor(rgb: 0xF5F5F5)
    }
    
    func setTimer(startTime: Int) {
        timer = Timer.publish(every: 1,tolerance: 0.9, on: .main, in: .default)
        timer?
            .autoconnect()
            .scan(startTime) { counter, _ in counter + 1 }
            .sink { [self] counter in
                if counter == 301 {
                    timer?.connect().cancel()
                } else {
                    timeLabel.text = counter.numberAsTime()
                }
            }.store(in: &cancellables)
    }
    
    func cancelTimer() {
        timer?.connect().cancel()
        timer = nil
    }
    
    func setUpTimerText(startTime: Int) {
        timeLabel.text = startTime.numberAsTime()
    }
}
