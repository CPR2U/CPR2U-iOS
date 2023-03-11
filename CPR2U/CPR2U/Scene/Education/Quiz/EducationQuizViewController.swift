//
//  EducationQuizViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class EducationQuizViewController: UIViewController {

    private let questionView = QuizQuestionView()
    private lazy var choiceView: UIView = {
        var view = UIView()
        if choiceNum == 2 {
            view = OXQuizChoiceView()
        } else {
            view = MultiQuizChoiceView()
        }
        return view
    }()
    
    private let multiChoiceView = MultiQuizChoiceView()
    
    private let answerLabel = UILabel()
    private let answerDescriptionLabel = UILabel()
    
    private let submitButton = UIButton()
    
    private let choiceNum = 4
    private let isSolved = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpStyle()
        setUpText()
        setUpAction()
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        
        [
            questionView,
            choiceView,
            submitButton,
            answerLabel,
            answerDescriptionLabel
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            questionView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: make.space24),
            questionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            questionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            questionView.heightAnchor.constraint(equalToConstant: 148)
            
        ])
        
        NSLayoutConstraint.activate([
            choiceView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: choiceNum == 2 ? 78 : 36),
            choiceView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            choiceView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            choiceView.heightAnchor.constraint(equalToConstant: choiceNum == 2 ? 80 : 234)
        ])
        
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            submitButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        NSLayoutConstraint.activate([
            answerLabel.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 200),
            answerLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            answerLabel.widthAnchor.constraint(equalToConstant: 300),
            answerLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            answerDescriptionLabel.topAnchor.constraint(equalTo: answerLabel.bottomAnchor),
            answerDescriptionLabel.centerXAnchor.constraint(equalTo: answerLabel.centerXAnchor),
            answerDescriptionLabel.widthAnchor.constraint(equalToConstant: 300),
            answerDescriptionLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setUpStyle() {
        answerLabel.font = UIFont(weight: .bold, size: 18)
        answerLabel.textColor = .mainBlack
        answerLabel.textAlignment = .center
        answerDescriptionLabel.font = UIFont(weight: .regular, size: 18)
        answerDescriptionLabel.textColor = .mainBlack
        answerDescriptionLabel.textAlignment = .center
        answerDescriptionLabel.numberOfLines = 3
        answerDescriptionLabel.adjustsFontSizeToFitWidth = true
        answerDescriptionLabel.minimumScaleFactor = 0.5
        
        submitButton.backgroundColor = .mainLightRed
        submitButton.setTitleColor(.mainBlack, for: .normal)
        submitButton.titleLabel?.font = UIFont(weight: .bold, size: 20)
    }
    
    private func setUpText() {
        
        answerLabel.text = "Correct!"
        answerDescriptionLabel.text = "Trailing is really important component for what I'm saying now do you understandararara"
        submitButton.setTitle(isSolved ? "Next" : "Confirm", for: .normal)
        
    }
    
    func setUpAction() {
        
    }
    
}
