//
//  QuizQuestionView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class QuizQuestionView: UIView {

    private let questionNumberLabel = UILabel()
    private let questionLabel = UILabel()
    private let questionLeftDecoLine = UIView()
    
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
        [
            questionNumberLabel,
            questionLabel,
            questionLeftDecoLine
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            questionNumberLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            questionNumberLabel.topAnchor.constraint(equalTo: self.topAnchor),
            questionNumberLabel.widthAnchor.constraint(equalToConstant: 70),
            questionNumberLabel.heightAnchor.constraint(equalToConstant: 38),
        ])
        
        NSLayoutConstraint.activate([
            questionLeftDecoLine.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: make.space24),
            questionLeftDecoLine.topAnchor.constraint(equalTo: questionNumberLabel.bottomAnchor, constant: make.space24),
            questionLeftDecoLine.widthAnchor.constraint(equalToConstant: 3),
            questionLeftDecoLine.heightAnchor.constraint(equalToConstant: 75),
        ])
        
        NSLayoutConstraint.activate([
            questionLabel.leadingAnchor.constraint(equalTo: questionLeftDecoLine.trailingAnchor, constant: make.space8),
            questionLabel.centerYAnchor.constraint(equalTo: questionLeftDecoLine.centerYAnchor),
            questionLabel.widthAnchor.constraint(equalToConstant: 295),
            questionLabel.heightAnchor.constraint(equalToConstant: 95),
        ])
    }
    
    private func setUpLayout() {
        
        questionNumberLabel.font = UIFont(weight: .bold, size: 28)
        questionNumberLabel.textColor = .mainRed
        
        questionLabel.font = UIFont(weight: .bold, size: 20)
        questionLabel.textColor = .mainBlack
        questionLabel.numberOfLines = 3
        questionLabel.adjustsFontSizeToFitWidth = true
        questionLabel.minimumScaleFactor = 0.5
        
        questionLeftDecoLine.backgroundColor = .mainLightRed
        
    }
    
    private func setUpText() {
        questionNumberLabel.text = "Q. 01"
        questionLabel.text = "When you find someone who has fallen, you have to compress his chest instantly."
    }
}
