//
//  EducationViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/20.
//

import Combine
import UIKit


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

enum TimerType: Int {
    case lecture = 5 // 3000
    case posture = 10 // 120
    case other = 0
}

final class EducationViewModel: OutputOnlyViewModelType {
    
    private let eduManager: EducationManager
    
    private let eduName: [String] = ["Lecture" , "Quiz", "Pose Practice"]
    private let eduDescription: [String] = ["Video lecture for CPR angel certificate", "Let’s check your CPR study", "Posture practice to get CPR angel certificate"]
    private var eduStatusArr:[Bool] = []
    private var input: Input?
    
    private var currentTimerType = TimerType.other
    let timer = Timer.publish(every: 1, on: .current, in: .common)
    
    init() {
        eduManager = EducationManager(service: APIManager())
        
        Task {
            try await receiveEducationStatus()
        }
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
        let nickname: CurrentValueSubject<String, Never>?
        let certificateStatus: CurrentValueSubject<CertificateStatus, Never>?
        let progressPercent: CurrentValueSubject<Float, Never>?
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
    
    func timeLimit() -> Int {
        currentTimerType.rawValue
    }
    
    func transform() -> Output {
        guard let input = input else { return Output(nickname: nil, certificateStatus: nil, progressPercent: nil) }
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
    
    func setTimer() -> AnyCancellable {
        return timer
            .autoconnect()
            .scan(0) { counter, _ in counter + 1 }
            .sink { [self] counter in
                let count = currentTimerType.rawValue
                if counter == count {
                    switch currentTimerType {
                    case .lecture:
                        Task {
                            try await self.saveLectureProgress()
                        }
                    case .posture:
                        Task {
                            try await self.savePosturePracticeResult(score: 90)
                        }
                    case .other:
                        break
                    }
                    self.timer.connect().cancel()
                }
            }
    }
    
    func updateTimerType(vc: UIViewController) {
        if (vc as? LectureViewController) != nil {
            currentTimerType = .lecture
        } else if (vc as? PosePracticeViewController) != nil {
            currentTimerType = .posture
        }
    }
    
    func receiveEducationStatus() async throws {
        let result = Task { () -> UserInfo? in
            let eduResult = try await eduManager.getEducationProgress()
            return eduResult.data
        }
        
        do {
            let data = try await result.value
        
            let progressPercent = Float(data?.progress_percent ?? 0)
            let isLectureCompleted = data?.is_lecture_completed == 2
            let isQuizCompleted = data?.is_quiz_completed == 2
            let isPostureCompleted = data?.is_posture_completed == 2
            input = Input(nickname: data?.nickname ?? "", angelStatus: data?.angel_status ?? 0, progressPercent: progressPercent, leftDay: data?.days_left_until_expiration, isLectureCompleted: isLectureCompleted, isQuizCompleted: isQuizCompleted, isPostureCompleted: isPostureCompleted)
            eduStatusArr = [isLectureCompleted, isQuizCompleted, isPostureCompleted]
        } catch(let error) {
            print(error)
        }
    }
    
    // MARK: TEST NOT YET
    func saveLectureProgress() async throws -> Bool {
        let result = Task {
            let eduResult = try await eduManager.saveLectureProgress(lectureId: 1)
            return eduResult.success
        }
        return try await result.value
    }
    
    func savePosturePracticeResult(score: Int) async throws -> Bool {
        let result = Task {
            let eduResult = try await eduManager.savePosturePracticeResult(score: score)
            print(eduResult.success)
            print(eduResult.data)
            return eduResult.success
        }
        return try await result.value
    }
    
    // MARK: TEST NOT YET
    func getLecture() async throws -> String? {
        let result = Task { () -> String? in
            let eduResult = try await eduManager.getLecture()
            return eduResult.data?.lecture_list[0].video_url
        }
        return try await result.value
    }
    
    // MARK: TEST NOT YET
    func getPostureLecture() async throws -> String? {
        let result = Task { () -> String? in
            let eduResult = try await eduManager.getPostureLecture()
            return eduResult.data?.video_url
        }
        return try await result.value
    }
}
