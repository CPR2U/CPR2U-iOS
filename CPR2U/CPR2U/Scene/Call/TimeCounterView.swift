//
//  TimeCounterView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/25.
//

import UIKit

final class TimeCounterView: UIView {
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 98)
        label.textColor = .mainRed
        label.shadowColor = UIColor(rgb: 0xB50000)
        label.numberOfLines = 3
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstriants()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstriants() {
        self.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant:100),
            timeLabel.heightAnchor.constraint(equalToConstant:100)
        ])
    }
    
    private func setUpStyle() {
        backgroundColor = .mainRed.withAlphaComponent(0.5)
    }
}
