//
//  QuizChoiceView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import Combine
import CombineCocoa
import UIKit

public class QuizChoiceView: UIView {
    public var choices: [UIButton] = []
    private var viewModel: QuizViewModel?
    private var cancellables = Set<AnyCancellable>()
    
    required init(quizType: QuizType, viewModel: QuizViewModel) {
        super.init(frame: CGRect.zero)
        
        for _ in 0..<quizType.rawValue {
            choices.append(UIButton())
        }
        
        self.viewModel = viewModel
        setUpAction()
        bind(quizType: quizType, viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpAction() {
        for (index, choice) in choices.enumerated() {
            choice.tapPublisher.sink { [weak self] in
                self?.viewModel?.updateSelectedAnswerIndex(index: index)
            }
            .store(in: &cancellables)
        }
    }
    
    private func bind(quizType: QuizType, viewModel: QuizViewModel) {
        viewModel.selectedAnswerIndex.sink { [weak self] index in
            if index == -1 {
                self?.resetButtonStatus()
            } else {
                guard quizType == viewModel.currentQuizType() else { return }
                self?.choices[index].changeButtonStyle(isSelected: true)
                let otherChoices = self?.choices.filter { $0 != self?.choices[index] }
                otherChoices?.forEach({
                    $0.changeButtonStyle(isSelected: false)
                })
            }
        }.store(in: &cancellables)
    }
    
    private func resetButtonStatus() {
        for choice in choices {
            choice.changeButtonStyle(isSelected: false)
        }
    }
    
    func setUpText(_ answers: [String]? = nil) {
        if answers == nil {
            choices[0].setTitle("O", for: .normal)
            choices[1].setTitle("X", for: .normal)
        } else {
            for (index, choice) in choices.enumerated() {
                choice.setTitle(answers?[index], for: .normal)
            }
        }
    }
}

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

final class MultiQuizChoiceView: QuizChoiceView {
    
    init (viewModel: QuizViewModel) {
        super.init(quizType: .multi, viewModel: viewModel)
        
        setUpConstraints()
        setUpText()
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
}
