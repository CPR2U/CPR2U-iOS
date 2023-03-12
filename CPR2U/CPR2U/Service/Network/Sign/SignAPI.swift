//
//  SignAPI.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/12.
//

import Foundation
import Moya

class SignAPI {
    
    var signProvider = MoyaProvider<SignService>()
    
    func phoneNumberVertify(phoneNumber: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        signProvider.request(.phoneNumberVertify(phoneNumber: phoneNumber)) { result in
            switch result {
            case .success (let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SMSCodeResult.self)
                completion(networkResult)
            case .failure (let error):
                print(error)
            }
        }
    }
    
    func nicknameVertify(nickname: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        signProvider.request(.nicknameVertify(nickname: nickname)) { result in
            switch result {
            case .success (let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SMSCodeResult.self)
                completion(networkResult)
            case .failure (let error):
                print(error)
            }
        }
    }
    
    func signIn(phoneNumber: String, deviceToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        signProvider.request(.signIn(phoneNumber: phoneNumber, deviceToken: deviceToken)) { result in
            switch result {
            case .success (let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SignInResult.self)
                completion(networkResult)
            case .failure (let error):
                print(error)
            }
        }
    }
    
    func signUp(nickname: String, phoneNumber: String, deviceToken: String, completion: @escaping (NetworkResult<Any>) -> Void) {
        signProvider.request(.signUp(nickname: nickname, phoneNumber: phoneNumber, deviceToken: deviceToken)) { result in
            switch result {
            case .success (let response):
                let statusCode = response.statusCode
                let data = response.data
                let networkResult = self.judgeStatus(by: statusCode, data, SignUpResult.self)
                completion(networkResult)
            case .failure (let error):
                print(error)
            }
        }
    }
    
    private func judgeStatus<T: Codable>(by statusCode: Int, _ data: Data, _ object: T.Type) -> NetworkResult<Any> {
        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(NetworkResponse<T>.self, from: data)
        else { return .decodeError }
        switch statusCode {
        case 200:
            return .success(decodedData.data as Any)
        default:
            return .fail(decodedData.status)
        }
    }
}
