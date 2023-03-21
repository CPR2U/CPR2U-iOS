//
//  EducationViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/20.
//

import Foundation
import Combine

enum AngelStatus: Int {
    case acquired
    case expired
    case unacquired

    func certificationImageName() -> String {
        switch self {
        case .acquired:
            return "heart_person"
        case .expired, .unacquired:
            return "person"
        }
    }
    
    func certificationStatus() -> String {
        switch self {
        case .acquired:
            return "ACQUIRED"
        case .expired:
            return "EXPIRED"
        case .unacquired:
            return "UNACQUIRED"
        }
    }
}

final class EducationViewModel: DefaultViewModelType {
    private let eduName: [String] = ["Lecture" , "Quiz", "Pose Practice"]
    private let eduDescription: [String] = ["Video lecture for CPR angel certificate", "Let’s check your CPR study", "Posture practice to get CPR angel certificate"]
    private var eduStatusArr:[Bool] = []
    
    init() {
        // MARK: API NETWORK
        let educationStatusArr: [Bool] = [true, false, false]
        eduStatusArr = educationStatusArr
    }
    
    struct Input {
        let nickname: String
        let angelStatus: Int
        let progressPercent: Float
        let leftDay: Int?
        let isLectureCompleted: Bool
        let isQuizCompleted: Bool
        let isPostureCompleted: Bool
    }
    
    struct CertificateStatus {
        let status: AngelStatus
        let leftDay: Int?
    }
    
    struct Output {
        let nickname: CurrentValueSubject<String, Never>
        let certificateStatus: CurrentValueSubject<CertificateStatus, Never>
        let progressPercent: CurrentValueSubject<Float, Never>
    }
    
    func educationName() -> [String] {
        return eduName
    }
    
    func educationDescription() -> [String] {
        return eduDescription
    }
    
    func educationStatus() -> [Bool] {
        return eduStatusArr
    }
    
    func transform(input: Input) -> Output {
        let nickname: CurrentValueSubject<String, Never> = CurrentValueSubject(input.nickname)
        
        let certificateStatus: CurrentValueSubject<CertificateStatus, Never> = {
            guard let status = AngelStatus(rawValue: input.angelStatus) else {
                return CurrentValueSubject(CertificateStatus(status: AngelStatus.unacquired, leftDay: nil))
            }
            
            guard let leftDayNum = input.leftDay else {
                return CurrentValueSubject(CertificateStatus(status: status, leftDay: nil))
            }
 
            return CurrentValueSubject(CertificateStatus(status: status, leftDay: leftDayNum))
            
        }()
        
        let progressPercent = input.progressPercent
        
        return Output(nickname: nickname, certificateStatus: certificateStatus, progressPercent: CurrentValueSubject(progressPercent))
    }
}
