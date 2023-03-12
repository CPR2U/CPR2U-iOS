//
//  SignManager.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/12.
//

import Foundation
import Moya

protocol SignService {
    func phoneNumberVerify(phoneNumber: String) async throws -> (success: Bool, data: SMSCodeResult?)
    func nicknameVerify(nickname: String) async throws -> (success: Bool, data: NicknameVerifyResult?)
    func signIn(phoneNumber: String, deviceToken: String) async throws -> (success: Bool, data: SignInResult?)
    func signUp(nickname: String, phoneNumber: String, deviceToken: String) async throws -> (success: Bool, data: SignUpResult?)
}

struct SignManager: SignService {
    
    private let service: Requestable
    
    init(service: Requestable) {
        self.service = service
    }
    
    func phoneNumberVerify(phoneNumber: String) async throws -> (success: Bool, data: SMSCodeResult?) {
        let request = SignEndPoint
            .phoneNumberVerify(phoneNumber: phoneNumber)
            .createRequest()
        return try await self.service.request(request)
    }
    
    func nicknameVerify(nickname: String) async throws -> (success: Bool, data: NicknameVerifyResult?) {
        let request = SignEndPoint
            .nicknameVerify(nickname: nickname)
            .createRequest()
        return try await self.service.request(request)
        }
    
    func signIn(phoneNumber: String, deviceToken: String) async throws -> (success: Bool, data: SignInResult?) {
        let request = SignEndPoint
            .signIn(phoneNumber: phoneNumber, deviceToken: deviceToken)
            .createRequest()
        return try await self.service.request(request)
    }
    
    func signUp(nickname: String, phoneNumber: String, deviceToken: String) async throws -> (success: Bool, data: SignUpResult?) {
        let request = SignEndPoint
            .signUp(nickname: nickname, phoneNumber: phoneNumber, deviceToken: deviceToken)
            .createRequest()
        return try await self.service.request(request)
    }
}
