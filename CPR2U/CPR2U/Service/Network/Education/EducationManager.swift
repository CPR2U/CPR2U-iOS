//
//  EducationManager.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/22.
//

import Foundation

protocol EducationService {
    func saveQuizResult() async throws -> (Bool, QuizResult?)
    func saveLectureProgress(lectureId: Int) async throws -> (Bool, LectureProgressResult?)
    func savePosturePracticeResult(score: Int) async throws -> (Bool, PosturePracticeResult?)
    func getEducationProgress() async throws -> (Bool, UserInfo?)
    func getQuizList() async throws -> (Bool, [QuizInfo]?)
    func getLecture() async throws -> (Bool, LectureProgressInfo?)
    func getPostureLecture() async throws -> (Bool, PostureLectureInfo?)
}

struct EducationManager: EducationService {
    
    private let service: Requestable
    
    init(service: Requestable) {
        self.service = service
    }
    
    func saveQuizResult() async throws -> (Bool, QuizResult?) {
        let request = EducationEndPoint
            .saveQuizResult
            .createRequest()
        return try await self.service.request(request)
    }
    
    func saveLectureProgress(lectureId: Int) async throws -> (Bool, LectureProgressResult?) {
        let request = EducationEndPoint
            .saveLectureProgress(lectureId: lectureId)
            .createRequest()
        return try await self.service.request(request)
    }
    
    func savePosturePracticeResult(score: Int) async throws -> (Bool, PosturePracticeResult?) {
        let request = EducationEndPoint
            .savePosturePracticeResult(score: score)
            .createRequest()
        return try await self.service.request(request)
    }
    
    func getEducationProgress() async throws -> (Bool, UserInfo?) {
        let request = EducationEndPoint
            .getEducationProgress
            .createRequest()
        return try await self.service.request(request)
    }
    
    func getQuizList() async throws -> (Bool, [QuizInfo]?) {
        let request = EducationEndPoint
            .getQuizList
            .createRequest()
        return try await self.service.request(request)
    }
    
    func getLecture() async throws -> (Bool, LectureProgressInfo?) {
        let request = EducationEndPoint
            .getLecture
            .createRequest()
        return try await self.service.request(request)
    }
    
    func getPostureLecture() async throws -> (Bool, PostureLectureInfo?) {
        let request = EducationEndPoint
            .getPostureLecture
            .createRequest()
        return try await self.service.request(request)
    }
}
