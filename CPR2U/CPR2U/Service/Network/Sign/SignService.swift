//
//  SignService.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/11.
//

import Foundation
import Moya

enum SignService {
    case phoneNumberVertify (phoneNumber: String)
    case nicknameVertify (nickname: String)
    case signIn (phoneNumber: String, deviceToken: String)
    case signUp (nickname: String, phoneNumber: String, deviceToken: String)
    // autoLogin
}

extension SignService: TargetType {
    var baseURL: URL {
        return URL(string: URLs.baseURL)!
    }
    
    var path: String {
        switch self {
        case .phoneNumberVertify:
            return URLs.phoneNumberVertifyURL
        case .nicknameVertify:
            return URLs.nicknameVertifyURL
        case .signIn:
            return URLs.signInURL
        case .signUp:
            return URLs.signUpURL
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .phoneNumberVertify, .signIn, .signUp:
            return .post
        case .nicknameVertify:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .phoneNumberVertify(let phoneNumber):
            let params : [String : String] = ["phone_number" : phoneNumber]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default )
        case .nicknameVertify(let nickname):
            let params : [String : String] = ["nickname" : nickname ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString )
        case .signIn(let phoneNumber, let deviceToken):
            let params : [String : String] = [ "phone_number" : phoneNumber, "device_token" : deviceToken ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default )
        case .signUp(let nickname, let phoneNumber, let deviceToken):
            let params : [String : String] = ["nickname" : nickname, "phone_number" : phoneNumber, "device_token" : deviceToken ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
