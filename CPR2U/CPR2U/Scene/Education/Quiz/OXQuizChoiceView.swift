//
//  OXQuizChoiceView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/18.
//

import UIKit

final class OXQuizChoiceView: QuizChoiceView {
    
    init (viewModel: QuizViewModel) {
        super.init(quizType: .ox, viewModel: viewModel)
        
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(quizType: QuizType, viewModel: QuizViewModel) {
        fatalError("init(quizType:viewModel:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 44
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        choices.forEach({
            stackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.topAnchor.constraint(equalTo: stackView.topAnchor).isActive = true
            $0.widthAnchor.constraint(equalToConstant: 108).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 80).isActive = true
        })
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 260),
            stackView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            choices[0].leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            choices[1].trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
        ])
    }
    
    private func setUpStyle() {
        choices.forEach({
            $0.backgroundColor = UIColor.mainRed.withAlphaComponent(0.05)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.mainRed.cgColor
            $0.layer.cornerRadius = 20
            $0.titleLabel?.font = UIFont(weight: .bold, size: 36)
            $0.setTitleColor(.mainBlack, for: .normal)
        })
    }
}
