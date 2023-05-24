//
//  EvaluationResultView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class EvaluationResultView: UIView {
    private let evaluationTargetImageView = UIImageView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 16)
        label.textColor = .mainWhite
        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
        return label
    }()
    
    private let descriptionImageView = UIImageView()
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 14)
        label.textColor = .mainWhite
        label.textAlignment = .center
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .regular, size: 14)
        label.textColor = .mainWhite
        label.textAlignment = .center
//        label.adjustsFontSizeToFitWidth = true
//        label.minimumScaleFactor = 0.5
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
//        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.top
        stackView.spacing   = make.space12
        
        let titleStackView = UIStackView()
        titleStackView.axis = NSLayoutConstraint.Axis.horizontal
        titleStackView.distribution  = UIStackView.Distribution.equalSpacing
        titleStackView.alignment = UIStackView.Alignment.center
        titleStackView.spacing   = make.space12
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        [
            titleStackView,
            descriptionImageView,
            resultLabel,
            descriptionLabel
        ].forEach({
            stackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: stackView.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            titleStackView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        [
            evaluationTargetImageView,
            titleLabel
        ].forEach({
            titleStackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        
        NSLayoutConstraint.activate([
            evaluationTargetImageView.topAnchor.constraint(equalTo: titleStackView.topAnchor),
            evaluationTargetImageView.leadingAnchor.constraint(equalTo: titleStackView.leadingAnchor),
            evaluationTargetImageView.widthAnchor.constraint(equalToConstant: 28),
            evaluationTargetImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: evaluationTargetImageView.trailingAnchor, constant: make.space4),
            titleLabel.trailingAnchor.constraint(equalTo: titleStackView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: evaluationTargetImageView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            descriptionImageView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: make.space8),
            descriptionImageView.centerXAnchor.constraint(equalTo: titleStackView.centerXAnchor),
            descriptionImageView.widthAnchor.constraint(equalToConstant: 48),
            descriptionImageView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: descriptionImageView.bottomAnchor, constant: make.space8),
            resultLabel.centerXAnchor.constraint(equalTo: descriptionImageView.centerXAnchor),
            resultLabel.widthAnchor.constraint(equalToConstant: 200),
            resultLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: resultLabel.bottomAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: resultLabel.centerXAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 200),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 21)
        ])
    }
    
    func setImage(imgName systemName: String) {
        let config = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular, scale: .medium)
        evaluationTargetImageView.image = UIImage(systemName: systemName, withConfiguration: config)?.withTintColor(.mainWhite, renderingMode: .alwaysOriginal)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setResultImageView(isSuccess: Bool) {
        let image = isSuccess ? UIImage(named: "check_badge.png") : UIImage(named: "x_mark.png")
        descriptionImageView.image = image
    }
    
    func setResultLabelText(as text: String) {
        resultLabel.text = text
    }
    
    func setDescriptionLabelText(as text: String) {
        descriptionLabel.text = text
    }
}
