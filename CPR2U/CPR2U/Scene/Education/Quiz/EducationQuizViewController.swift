//
//  EducationQuizViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit
import Combine

final class EducationQuizViewController: UIViewController {

    private let questionView = QuizQuestionView(questionNumber: 1, question: "When you find someone who has fallen, you have to compress his chest instantly.")
    
    private lazy var oxChoiceView = OXQuizChoiceView(viewModel: quizViewModel)
    private lazy var multiChoiceView = MultiQuizChoiceView(viewModel: quizViewModel)
    
    private let noticeView = CustomNoticeView(noticeAs: .quiz)
    
    private let answerLabel = UILabel()
    private let answerDescriptionLabel = UILabel()
    
    private let submitButton = UIButton()
    var answer = 0
    
    private let quizViewModel = QuizViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpStyle()
        setUpText()
        updateQuiz(quiz: quizViewModel.quizInit())
        bind(to: quizViewModel)
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        
        [
            questionView,
            oxChoiceView,
            multiChoiceView,
            submitButton,
            answerLabel,
            answerDescriptionLabel,
            noticeView
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
        
        [oxChoiceView, multiChoiceView].forEach({ choiceView in
            choiceView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16).isActive = true
            choiceView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16).isActive = true
        })
        
        NSLayoutConstraint.activate([
            oxChoiceView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 78),
            oxChoiceView.heightAnchor.constraint(equalToConstant: 80),
            multiChoiceView.topAnchor.constraint(equalTo: questionView.bottomAnchor, constant: 36),
            multiChoiceView.heightAnchor.constraint(equalToConstant: 280)
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

        NSLayoutConstraint.activate([
            noticeView.topAnchor.constraint(equalTo: view.topAnchor),
            noticeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noticeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noticeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpStyle() {
        view.backgroundColor = .mainWhite
        
        answerLabel.font = UIFont(weight: .bold, size: 18)
        answerLabel.textColor = .mainBlack
        answerLabel.textAlignment = .center
        answerDescriptionLabel.font = UIFont(weight: .regular, size: 18)
        answerDescriptionLabel.textColor = .mainBlack
        answerDescriptionLabel.textAlignment = .center
        answerDescriptionLabel.numberOfLines = 3
        answerDescriptionLabel.adjustsFontSizeToFitWidth = true
        answerDescriptionLabel.minimumScaleFactor = 0.5
        
        answerLabel.isUserInteractionEnabled = false
        answerDescriptionLabel.isUserInteractionEnabled = false
        
        submitButton.backgroundColor = .mainLightRed
        submitButton.setTitleColor(.mainBlack, for: .normal)
        submitButton.titleLabel?.font = UIFont(weight: .bold, size: 20)
    }
    
    private func setUpText() {
        answerLabel.text = ""
        answerDescriptionLabel.text = ""
        submitButton.setTitle("Confirm", for: .normal)
        
    }
    
    private func bind(to viewModel: QuizViewModel) {
        viewModel.selectedAnswerIndex.sink { index in
                if (index != -1) {
                    print("SELECTED ONE!")
                    viewModel.isSelected()
                }
            }
        .store(in: &cancellables)
        
        submitButton.tapPublisher.sink { [weak self] _ in
            self?.nextQuiz()
        }.store(in: &cancellables)
    }
    
    private func nextQuiz() {
        let output = quizViewModel.transform()
        
        output.isCorrect?.sink { [weak self] isCorrect in
            self?.answerLabel.isHidden = false
            self?.answerDescriptionLabel.isHidden = false
            self?.answerLabel.text = isCorrect ? "Correct!" : "Wrong!"
            self?.submitButton.setTitle("Next", for: .normal)
        }.store(in: &cancellables)
        
        output.quiz?.sink { quiz in
            self.updateQuiz(quiz: quiz)
        }.store(in: &cancellables)
        
        output.isQuizEnd.sink { [weak self] isQuizEnd in
            
            guard let isQuizAllCorrect = self?.quizViewModel.isQuizAllCorrect() else { return }
            guard let quizResultString = self?.quizViewModel.quizResultString() else { return }
            if isQuizEnd {
                print("HHHHHHHHHHHHH")
                if isQuizAllCorrect {
                    self?.noticeView.setQuizResultNotice(isAllCorrect: true)
                    self?.noticeView.noticeAppear()
                } else {
                    self?.noticeView.setQuizResultNotice(isAllCorrect: false, quizResultString: quizResultString)
                    self?.noticeView.noticeAppear()
                }
            }
        }.store(in: &cancellables)
    }
    
    func updateQuiz(quiz: Quiz) {
        quizViewModel.updateSelectedAnswerIndex(index: -1)
        questionView.setUpText(questionNumber: quiz.questionNumber, question: quiz.question)
        
        switch quiz.questionType {
        case .ox:
            updateChoiceView(current: multiChoiceView, as: oxChoiceView)
            oxChoiceView.setUpText()
        case .multi:
            updateChoiceView(current: oxChoiceView, as: multiChoiceView)
            multiChoiceView.setUpText(quiz.answerList)
        }
        
        answerDescriptionLabel.text = quiz.answerDescription
        answerLabel.isHidden = true
        answerDescriptionLabel.isHidden = true
        submitButton.setTitle("Confirm", for: .normal)
    }
    
    func updateChoiceView(current: QuizChoiceView, as will: QuizChoiceView) {
        current.alpha = 0.0
        current.isUserInteractionEnabled = false
        will.alpha = 1.0
        will.isUserInteractionEnabled = true
    }
}
