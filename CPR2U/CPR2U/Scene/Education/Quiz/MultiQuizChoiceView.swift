//
//  MultiQuizChoiceView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

protocol QuizChoiceViewDelegate: AnyObject {
    func isSelectedAnswer(index: Int)
}

final class MultiQuizChoiceView: UIView {

    private let choices = [UIButton(), UIButton(), UIButton(), UIButton()]
    weak var delegate: QuizChoiceViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpText()
        setUpStyle()
        setUpAction()
        print("here")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing = 26
        
        self.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        
        choices.forEach({
            stackView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            $0.widthAnchor.constraint(equalToConstant: 334).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 52).isActive = true
            $0.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        })
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: self.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 260)
        ])
        
        NSLayoutConstraint.activate([
            choices[0].topAnchor.constraint(equalTo: stackView.topAnchor),
            choices[1].topAnchor.constraint(equalTo: choices[0].bottomAnchor, constant: 26),
            choices[2].topAnchor.constraint(equalTo: choices[1].bottomAnchor, constant: 26),
            choices[3].topAnchor.constraint(equalTo: choices[2].bottomAnchor, constant: 26)
        ])
    }
    
    private func setUpStyle() {
        choices.forEach({
            $0.backgroundColor = UIColor.mainRed.withAlphaComponent(0.05)
            $0.layer.borderWidth = 2
            $0.layer.borderColor = UIColor.mainRed.cgColor
            $0.layer.cornerRadius = 20
            $0.titleLabel?.font = UIFont(weight: .regular, size: 26)
            $0.setTitleColor(.mainBlack, for: .normal)
        })
    }
    
    private func setUpText() {
        let tempChoices = ["Top", "Bottom", "Leading", "Trailing"]
        
        for (index, choice) in choices.enumerated() {
            choice.setTitle(tempChoices[index], for: .normal)
        }
    }
    
    private func setUpAction() {
        for choice in choices {
            choice.addTarget(self, action: #selector(didButtonClicked), for: .touchUpInside)
        }
    }
    
    @objc func didButtonClicked(_ sender: UIButton) {
        print("here")
        for (index, choice) in choices.enumerated() {
            if choice == sender {
                choice.isSelected = true
                choice.changeButtonStyle(isSelected: true)
                delegate?.isSelectedAnswer(index: index)
                
            } else {
                choice.isSelected = false
                choice.changeButtonStyle(isSelected: false)
            }
        }
    }
}
