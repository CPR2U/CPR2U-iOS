//
//  QuizViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/14.
//

import Foundation
import Combine

protocol ViewModelTypeTest {
    associatedtype Output

    func transform() -> Output
}

class QuizViewModel: ViewModelTypeTest {
    private var quizList: [Quiz] = []
    private var currentQuizIndex: Int = 0
    private var didSelectAnswer: Bool = false
    private var correctQuizNum: Int = 0
    var selectedAnswerIndex = CurrentValueSubject<Int, Never>(-1)
    
    init() {
        self.quizList = [Quiz(questionType: .ox, questionNumber: 1, question: "11111", answerIndex: 0, answerList: ["111", "111"], answerDescription: "asjdeeeeeeeeeeee"), Quiz(questionType: .multi, questionNumber: 2, question: "333333333", answerIndex: 3, answerList: ["123", "456", "789", "141"], answerDescription: "asjdifjaisjdfiaisdjfijaisdf"), Quiz(questionType: .multi, questionNumber: 3, question: "3333eww33333", answerIndex: 2, answerList: ["aaa", "bbb", "ccc", "ddd"], answerDescription: "wlqrjiji")]
    }
    
    struct Output {
        let quiz: CurrentValueSubject<Quiz, Never>?
        let isCorrect: CurrentValueSubject<Bool, Never>?
        let isQuizEnd: CurrentValueSubject<Bool, Never>
    }
     
    func isSelected() {
        print("SELECTED: ANSWER")
        didSelectAnswer = true
    }
    
    func isConfirmed() {
        print("CONFIRMED: ANSWER")
        didSelectAnswer = false
    }
    
    func quizInit() -> Quiz {
        return quizList[0]
    }
    
    func currentQuiz() -> Quiz {
        return quizList[currentQuizIndex]
    }
    func currentQuizType() -> QuizType {
        return quizList[currentQuizIndex].questionType
    }
    func updateSelectedAnswerIndex(index: Int) {
        selectedAnswerIndex.send(index)
    }
    
    func quizResultString() -> String {
        return "\(correctQuizNum)/\(quizList.count)"
    }
    
    func isQuizAllCorrect() -> Bool {
        print(correctQuizNum, " " , quizList.count)
        return correctQuizNum == quizList.count
    }
    // quiz 넘김을 위한 메소드
    func transform() -> Output {
        
        if selectedAnswerIndex.value == -1 {
            return Output(quiz: nil, isCorrect: nil, isQuizEnd: CurrentValueSubject<Bool, Never>(false))
        }
        
        var output: Output
        
        if didSelectAnswer {
            let isCorrect = selectedAnswerIndex.value == quizList[currentQuizIndex].answerIndex

            if isCorrect {
                correctQuizNum += 1
            }
            output = Output(quiz: nil, isCorrect: CurrentValueSubject(isCorrect), isQuizEnd: CurrentValueSubject<Bool, Never>(false))
            didSelectAnswer.toggle()
            print("RESULT: ", isCorrect ? "CORRECT" : "WRONG")
        } else {
            currentQuizIndex += 1
            if quizList.count == currentQuizIndex {
                print("THERE's no more next quiz")
                output = Output(quiz: nil, isCorrect: nil, isQuizEnd: CurrentValueSubject<Bool, Never>(true))
            } else {
                output = Output(quiz: CurrentValueSubject(quizList[currentQuizIndex]), isCorrect: nil, isQuizEnd: CurrentValueSubject<Bool, Never>(false))
                selectedAnswerIndex.send(-1)
                didSelectAnswer.toggle()
                print("NEXT QUIZ")
            }
        }
        
        return output
    }
    
}
