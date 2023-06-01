//
//  EducationViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/20.
//

import Combine
import UIKit

// Tensorflow 관련 수치 Notation은  추후 Refactoring 시 재검토 예정
enum CompressionRateStatus: String {
    case tooSlow = "Too Slow"
    case slow = "Slow"
    case adequate = "Adequate"
    case fast = "Fast"
    case tooFast = "Too Fast"
    case wrong = "Wrong"
    
    // 압박 속도
    // 190-250 : 33점
    // 170-270 : 22점
    // 150-290 : 11점
    var score: Int {
        switch self {
        case .adequate:
            return 33
        case .slow, .fast:
            return 22
        case .tooSlow, .tooFast:
            return 11
        case .wrong:
            return 0
        }
    }
    
    var description: String {
        switch self {
        case .tooSlow:
            return "It's too slow. Press faster"
        case .slow:
            return "It's slow. Press more faster"
        case .adequate:
            return "Good job! Very Adequate"
        case .fast:
            return "It's fast. Press more slower"
        case .tooFast:
            return "It's too fast. Press slower"
        case .wrong:
            return "Something went wrong. Try Again"
        }
    }
}

enum AngleStatus: String {
    case adequate = "Adequate"
    case almost = "Almost Adequate"
    case notGood = "Not Good"
    case bad = "Bad"
    
    // 팔 각도
    // CORRECT : NON-CORRECT
    // 7:3     : 33점
    // 6:4     : 22점
    // 5:5     : 11점
    // 나머지    : 5점
    var score: Int {
        switch self {
        case .adequate:
            return 33
        case .almost:
            return 22
        case .notGood:
            return 11
        case .bad:
            return 5
        }
    }
    
    var description: String {
        switch self {
        case .adequate:
            return "Good job! Very Nice angle!"
        case .almost:
            return "Almost there. Try again"
        case .notGood:
            return "Pay more attention to the angle of your arms"
        case .bad:
            return "You need some more practice"
        }
    }
}

enum PressDepthStatus: String {
    case deep = "Deep"
    case adequate = "Adequate"
    case shallow = "Slightly Shallow"
    case tooShallow = "Too Shallow"
    case wrong = "Wrong"
    
    // 압박 깊이
    // 30 이상    : 15
    // 18 - 30   : 33
    // 5 - 18   : 15
    // 0  - 5.  : 5
    var score: Int {
        switch self {
        case .deep:
            return 15
        case .adequate:
            return 33
        case .shallow:
            return 15
        case .tooShallow:
            return 5
        case .wrong:
            return 0
        }
    }
    
    var description: String {
        switch self {
        case .deep:
            return "Press slight"
        case .adequate:
            return "Good job! Very adequate!"
        case .shallow:
            return "Press little deeper"
        case .tooShallow:
            return "It's too shallow. Press deeply"
        case .wrong:
            return "Something went wrong. Try Again"
            
        }
    }
}

struct CertificateStatus {
    let status: AngelStatus
    let leftDay: Int?
}

enum AngelStatus: Int {
    case acquired
    case expired
    case unacquired
    
    func certificationImageName(_ isBig: Bool = false) -> String {
        switch self {
        case .acquired:
            return isBig == true ? "heart_person_big" : "heart_person"
        case .expired, .unacquired:
            return isBig == true ? "person_big" : "person"
        }
    }
    
    func getStatus() -> String {
        switch self {
        case .acquired:
            return "acq_status".localized()
        case .expired:
            return "exp_status".localized()
        case .unacquired:
            return "unacq_status".localized()
        }
    }
}

enum TimerType: Int {
    case lecture = 5//3001
    case posture = 15 //130
    case other = 0
}

enum EducationCourseInfo: String {
    case lecture = "course_lec"
    case quiz = "course_quiz"
    case pose = "course_pose"
    
    var name: String {
        return self.rawValue.localized()
    }
    
    var description: String {
        switch self {
        case .lecture:
            return "course_lec_des".localized()
        case .quiz:
            return "course_quiz_des".localized()
        case .pose:
            return "course_pose_des".localized()
        }
    }
    
    var timeValue: Int {
        switch self {
        case .lecture:
            return 50
        case .quiz:
            return 5
        case .pose:
            return 3
        }
    }
}
struct EducationCourse {
    var info: EducationCourseInfo
    var courseStatus = CurrentValueSubject<CourseStatus,Never>(.locked)
    
    init(course: EducationCourseInfo) {
        self.info = course
    }
}

final class EducationViewModel: AsyncOutputOnlyViewModelType {
    private let eduManager: EducationManager
    
//    private let _educationCourse: [EducationCourse] = [
//
//    ]
    
    @Published private(set) var educationCourse: [EducationCourse] = [
        EducationCourse(course: .lecture),
        EducationCourse(course: .quiz),
        EducationCourse(course: .pose)
    ]
    
    private var input: Input?
    
    private var currentTimerType = TimerType.other
    var timer = Timer.publish(every: 1, on: .current, in: .common)
    
    private var compressionRate: Int?
    private var angleRate: (correct: Int?, nonCorrect: Int?)
    private var pressDepthRate: CGFloat?
    
    init() {
        eduManager = EducationManager(service: APIManager())
        Task {
            self.input = try await initialize() ?? nil
        }
    }
    
    struct Input {
        let nickname: CurrentValueSubject<String, Never>
        let angelStatus: CurrentValueSubject<Int, Never>
        let progressPercent: CurrentValueSubject<Float, Never>
        let leftDay: CurrentValueSubject<Int?, Never>
    }
    
    struct Output {
        let nickname: CurrentValueSubject<String, Never>?
        let certificateStatus: CurrentValueSubject<CertificateStatus, Never>?
        let progressPercent: CurrentValueSubject<Float, Never>?
    }
    
    func timeLimit() -> Int {
        currentTimerType.rawValue
    }
    
    func transform() async throws -> Output {
        
        let output = Task { () -> Output in
            let userInfo = try await receiveEducationStatus()
            updateInput(data: userInfo)
            
            let certificateStatus: CurrentValueSubject<CertificateStatus, Never> = {
                guard let status = AngelStatus(rawValue: input?.angelStatus.value ?? 2) else {
                    return CurrentValueSubject(CertificateStatus(status: AngelStatus.unacquired, leftDay: nil))
                }
                
                guard let leftDayNum = input?.leftDay.value else {
                    return CurrentValueSubject(CertificateStatus(status: status, leftDay: nil))
                }
                
                return CurrentValueSubject(CertificateStatus(status: status, leftDay: leftDayNum))
                
            }()
            
            return Output(nickname: input?.nickname, certificateStatus: certificateStatus, progressPercent: input?.progressPercent)
        }
        
        return try await output.value
        
        
    }
    
    func updateTimerType(vc: UIViewController) {
        if (vc as? LectureViewController) != nil {
            currentTimerType = .lecture
        } else if (vc as? PosePracticeViewController) != nil {
            currentTimerType = .posture
        }
    }
    
    func receiveEducationStatus() async throws -> UserInfo? {
        let result = Task { () -> UserInfo? in
            let eduResult = try await eduManager.getEducationProgress()
            return eduResult.data
        }
        
        let data = try await result.value
        
        return data
    }
    
    func initialize() async throws -> Input? {
        let result = Task { () -> Input? in
            let eduResult = try await self.eduManager.getEducationProgress()
            guard let data = eduResult.data else { return nil }
            
            let progressPercent = Float(data.progress_percent)
            
            let completedStatusArr = [
                data.is_lecture_completed,
                data.is_quiz_completed,
                data.is_posture_completed
            ]
            
            for idx in 0..<completedStatusArr.count {
                if completedStatusArr[idx] == 2 {
                    educationCourse[idx].courseStatus.send(.completed)
                } else {
                    educationCourse[idx].courseStatus.send(.now)
                    if idx+1 <= completedStatusArr.count - 1 {
                        for i in idx+1..<completedStatusArr.count {
                            educationCourse[i].courseStatus.send(.locked)
                        }
                        break
                    }
                }
            }
            
            for i in 0..<completedStatusArr.count {
                print("idx: \(i) \(educationCourse[i].courseStatus.value)")
            }
            return Input(nickname: CurrentValueSubject(data.nickname), angelStatus: CurrentValueSubject(data.angel_status), progressPercent: CurrentValueSubject(progressPercent), leftDay: CurrentValueSubject(data.days_left_until_expiration))
        }
        return try await result.value
    }
    
    func saveLectureProgress() async throws -> Bool {
        let result = Task {
            let eduResult = try await eduManager.saveLectureProgress(lectureId: 1)
            let userInfo = try await receiveEducationStatus()
            updateInput(data: userInfo)
            return eduResult.success
        }
        return try await result.value
    }
    
    func savePosturePracticeResult(score: Int) async throws -> Bool {
        let result = Task {
            let eduResult = try await eduManager.savePosturePracticeResult(score: score)
            let userInfo = try await receiveEducationStatus()
            updateInput(data: userInfo)
            return eduResult.success
        }
        return try await result.value
    }
    
    func getLecture() async throws -> String? {
        let result = Task { () -> String? in
            let eduResult = try await eduManager.getLecture()
            return eduResult.data?.lecture_list[0].video_url
        }
        return try await result.value
    }
    
    func getPostureLecture() async throws -> String? {
        let result = Task { () -> String? in
            let eduResult = try await eduManager.getPostureLecture()
            return eduResult.data?.video_url
        }
        return try await result.value
    }
    
    func updateInput(data: UserInfo?) {
        let progressPercent = Float(data?.progress_percent ?? 0)
        
        DispatchQueue.main.async { [weak self] in
            self?.input?.nickname.send(data?.nickname ?? "")
            self?.input?.angelStatus.send(data?.angel_status ?? 0)
            self?.input?.progressPercent.send(progressPercent)
            self?.input?.leftDay.send(data?.days_left_until_expiration ?? nil)
            
            let completedStatusArr = [
                data?.is_lecture_completed,
                data?.is_quiz_completed,
                data?.is_posture_completed
            ]
            
            for idx in 0..<completedStatusArr.count {
                if completedStatusArr[idx] == 2 {
                    self?.educationCourse[idx].courseStatus.send(.completed)
                } else {
                    self?.educationCourse[idx].courseStatus.send(.now)
                    if idx+1 <= completedStatusArr.count - 1 {
                        for i in idx+1..<completedStatusArr.count {
                            self?.educationCourse[i].courseStatus.send(.locked)
                        }
                        break
                    }
                }
            }
        }
    }
    
    func judgePostureResult() -> (compResult: CompressionRateStatus, angleResult: AngleStatus, pressDepth: PressDepthStatus) {
        guard let compRate = compressionRate, let correct = angleRate.correct, let nonCorrect = angleRate.nonCorrect, let pressRate = pressDepthRate else { return (CompressionRateStatus.wrong, AngleStatus.bad, PressDepthStatus.shallow) }
        
        var compResult: CompressionRateStatus = .adequate
        switch compRate {
        case ...170:
            compResult = .tooSlow
        case 170...190:
            compResult = .slow
        case 190...250:
            compResult = .adequate
        case 250...270:
            compResult = .fast
        case 270...:
            compResult = .tooFast
        default:
            compResult = .wrong
        }
        var angleResult: AngleStatus = .adequate
        let totalAngleCount = Double(correct + nonCorrect)
        
        switch Double(correct) {
        case Double(totalAngleCount) * 0.7...totalAngleCount:
            angleResult = .adequate
        case Double(totalAngleCount) * 0.6...Double(totalAngleCount) * 0.7:
            angleResult = .almost
        case Double(totalAngleCount) * 0.5...Double(totalAngleCount) * 0.6:
            angleResult = .notGood
        default:
            angleResult = .bad
        }
        
        print(totalAngleCount)
        if totalAngleCount < 1000 {
            angleResult = .bad
        }
        
        var pressDepthResult: PressDepthStatus = .wrong
        
        switch pressRate {
        case 30.0... :
            pressDepthResult = .deep
        case 18.0..<30.0:
            pressDepthResult = .adequate
        case 5.0..<18.0:
            pressDepthResult = .shallow
        case 0.0..<5.0:
            pressDepthResult = .tooShallow
        default:
            pressDepthResult = .wrong
        }
        
        return (compResult, angleResult, pressDepthResult)
    }
    
    func setPostureResult(compCount: Int, armAngleCount: (correct: Int, nonCorrect: Int), pressDepth: CGFloat) {
        compressionRate = compCount
        angleRate.correct = armAngleCount.correct
        angleRate.nonCorrect = armAngleCount.nonCorrect
        pressDepthRate = pressDepth
        
    }
}
