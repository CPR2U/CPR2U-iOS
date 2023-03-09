//
//  CertificateStatusView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/09.
//

import UIKit

final class CertificateStatusView: UIView {

    private let certificateImage = UIImageView()
    private let greetingLabel = UILabel()
    private let certificateLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpLayout()
        setUpText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        let make = Constraints.shared
        
        let labelStackView   = UIStackView()
        labelStackView.axis  = NSLayoutConstraint.Axis.vertical
        labelStackView.distribution  = UIStackView.Distribution.equalSpacing
        labelStackView.alignment = UIStackView.Alignment.center
        
        [
            certificateImage,
            labelStackView
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })

        NSLayoutConstraint.activate([
            certificateImage.leadingAnchor.constraint(equalTo: super.leadingAnchor, constant: make.space24),
            certificateImage.centerYAnchor.constraint(equalTo: super.centerYAnchor),
            certificateImage.widthAnchor.constraint(equalToConstant: 28),
            certificateImage.heightAnchor.constraint(equalToConstant: 34)
        ])
        
        NSLayoutConstraint.activate([
            labelStackView.leadingAnchor.constraint(equalTo: certificateImage.trailingAnchor, constant: make.space16),
            labelStackView.centerYAnchor.constraint(equalTo: certificateImage.centerYAnchor),
            labelStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -make.space16),
            labelStackView.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        
        [
            greetingLabel,
            certificateLabel
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            greetingLabel.topAnchor.constraint(equalTo: labelStackView.topAnchor),
            greetingLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            greetingLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            greetingLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        NSLayoutConstraint.activate([
            certificateLabel.bottomAnchor.constraint(equalTo: labelStackView.bottomAnchor),
            certificateLabel.leadingAnchor.constraint(equalTo: labelStackView.leadingAnchor),
            certificateLabel.trailingAnchor.constraint(equalTo: labelStackView.trailingAnchor),
            certificateLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }
    
    private func setUpLayout() {
        self.layer.cornerRadius = 16
        self.layer.borderColor = UIColor.mainRed.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .mainLightRed
        
        certificateImage.image = UIImage(named: "person.png")
        
        greetingLabel.font = UIFont(weight: .regular, size: 12)
        greetingLabel.textColor = .mainBlack
        
        
        // TODO: 로직 구현 시, certificateLabel NAttributedText 적용 예정
        certificateLabel.font = UIFont(weight: .bold, size: 14)
        certificateLabel.textColor = .mainBlack
    }
    
    private func setUpText() {
        greetingLabel.text = "Hi HeartBeatingS2,"
        certificateLabel.text = "You are not a CPR ANGEL yet."
    }
}
