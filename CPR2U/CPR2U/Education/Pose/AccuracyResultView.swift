//
//  AccuracyResultView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class AccuracyResultView: UIView {
    
    private let accuracyTargetImageView = UIImageView()
    private let titleLabel = UILabel()
    private let percentLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpStyle()
        setUpText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        
        [
            accuracyTargetImageView,
            titleLabel,
            percentLabel,
            descriptionLabel
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            accuracyTargetImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: make.space14),
            accuracyTargetImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: make.space14),
            accuracyTargetImageView.widthAnchor.constraint(equalToConstant: 28),
            accuracyTargetImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: accuracyTargetImageView.trailingAnchor, constant: make.space8),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -make.space8),
            titleLabel.centerYAnchor.constraint(equalTo: accuracyTargetImageView.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -make.space16),
            descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 35)
        ])
        
        NSLayoutConstraint.activate([
            percentLabel.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -40),
            percentLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            percentLabel.widthAnchor.constraint(equalToConstant: 200),
            percentLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
        
    }
    
    private func setUpStyle() {
        self.layer.cornerRadius = 16
        self.layer.borderColor = UIColor.mainRed.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .mainLightRed.withAlphaComponent(0.05)
        
        titleLabel.font = UIFont(weight: .bold, size: 24)
        descriptionLabel.font = UIFont(weight: .bold, size: 24)
        
        [
            titleLabel,
            percentLabel,
            descriptionLabel
        ].forEach({
            $0.textColor = .mainBlack
        })
        
        titleLabel.textAlignment = .left
        percentLabel.textAlignment = .center
        descriptionLabel.textAlignment = .center
        
        percentLabel.adjustsFontSizeToFitWidth = true
        percentLabel.minimumScaleFactor = 0.5
    }
    
    private func setUpText() {
        titleLabel.text = "Accuracy"
        
        percentLabel.text = "96%"
        guard let text = percentLabel.text else { return }
        let attributedStr = NSMutableAttributedString(string: text)
        guard let numberFont = UIFont(weight: .bold, size: 80) else { return }
        guard let percentFont = UIFont(weight: .bold, size: 40) else { return }
        attributedStr.addAttribute(.font, value: numberFont, range: (text as NSString).range(of: "96"))
        attributedStr.addAttribute(.font, value: percentFont, range: (text as NSString).range(of: "%"))
        percentLabel.attributedText = attributedStr

        descriptionLabel.text = "PASSED!"
    }
}
