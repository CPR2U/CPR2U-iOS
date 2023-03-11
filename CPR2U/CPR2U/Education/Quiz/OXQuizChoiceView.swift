//
//  OXQuizChoiceView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class OXQuizChoiceView: UIView {

    private let leftChoice = UIButton()
    private let rightChoice = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpText()
        setUpStyle()
        setUpAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 44
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        [
            leftChoice,
            rightChoice
        ].forEach({
            stackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 260),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            leftChoice.topAnchor.constraint(equalTo: stackView.topAnchor),
            leftChoice.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
            leftChoice.widthAnchor.constraint(equalToConstant: 108),
            leftChoice.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            rightChoice.topAnchor.constraint(equalTo: stackView.topAnchor),
            rightChoice.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            rightChoice.widthAnchor.constraint(equalToConstant: 108),
            rightChoice.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setUpStyle() {
        [
            leftChoice,
            rightChoice
        ].forEach({
            $0.backgroundColor = UIColor.mainRed.withAlphaComponent(0.05)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.mainRed.cgColor
            $0.layer.cornerRadius = 20
            $0.titleLabel?.font = UIFont(weight: .bold, size: 36)
            $0.setTitleColor(.mainBlack, for: .normal)
        })
    }
    
    private func setUpText() {
        leftChoice.setTitle("O", for: .normal)
        rightChoice.setTitle("X", for: .normal)
    }
    
    private func setUpAction() {
        
    }
    
    
}
