//
//  EducationViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/20.
//

import Foundation
import Combine

enum AngelStatus: Int {
    case complete
    case expired
    case incomplete
}

enum EducationStatus: Int {
    case incomplete
    case lectureComplete
    case quizComplete
    case postureComplete
}

final class EducationViewModel: DefaultViewModelType {
    struct Input {
        let angelStatus: Int
        let progressPercent: Float
        let isLectureCompleted: Bool
        let isQuizCompleted: Bool
        let isPostureCompleted: Bool
    }
    
    struct Output {
        let angelStatus: CurrentValueSubject<AngelStatus, Never>
        let progressPercent: CurrentValueSubject<Float, Never>
        let educationStatus: CurrentValueSubject<EducationStatus, Never>
    }
    
    func transform(input: Input) -> Output {
        
        let angelStatus = AngelStatus(rawValue: input.angelStatus)
        let progressPercent = input.progressPercent
        let educationStatus: EducationStatus = {
            if input.isPostureCompleted {
                return EducationStatus.postureComplete
            } else if input.isQuizCompleted {
                return EducationStatus.quizComplete
            } else if input.isLectureCompleted {
                return EducationStatus.lectureComplete
            } else {
                return EducationStatus.incomplete
            }
        }()
        
        return Output(angelStatus: CurrentValueSubject(angelStatus ?? .incomplete), progressPercent: CurrentValueSubject(progressPercent), educationStatus: CurrentValueSubject(educationStatus))
    }
}
