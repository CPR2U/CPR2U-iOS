//
//  EducationProgressView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/09.
//

import UIKit

final class EducationProgressView: UIView {

    private let annotationLabel = UILabel()
    private let progressView = UIProgressView()
    
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
            annotationLabel,
            progressView
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            annotationLabel.topAnchor.constraint(equalTo: self.topAnchor),
            annotationLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: make.space6),
            annotationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            annotationLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: annotationLabel.bottomAnchor, constant: make.space2),
            progressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: make.space6),
            progressView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    private func setUpStyle() {
        annotationLabel.font = UIFont(weight: .regular, size: 11)
        annotationLabel.textColor = UIColor(rgb: 0x767676)
        
        progressView.trackTintColor = .mainLightRed.withAlphaComponent(0.05)
        progressView.progressTintColor = .mainRed
        progressView.layer.borderColor = UIColor.mainRed.cgColor
        progressView.layer.borderWidth = 1
        progressView.layer.cornerRadius = 8
        progressView.layer.sublayers![1].cornerRadius = 8
        progressView.clipsToBounds = true
        progressView.progress = 0.2
    }
    
    private func setUpText() {
        annotationLabel.text = "CPR Angel Certification Progress"
    }
}
