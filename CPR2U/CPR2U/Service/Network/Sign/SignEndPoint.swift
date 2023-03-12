//
//  SignEndPoint.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/11.
//

import Foundation

enum SignEndPoint {
    case phoneNumberVertify (phoneNumber: String)
    case nicknameVertify (nickname: String)
    case signIn (phoneNumber: String, deviceToken: String)
    case signUp (nickname: String, phoneNumber: String, deviceToken: String)
    // case autoLogin
}

extension SignEndPoint: EndPoint {
    
    var method: HttpMethod {
        switch self {
        case .phoneNumberVertify, .signIn, .signUp:
            return .POST
        case .nicknameVertify:
            return .GET
        }
    }
    
    var body: Data? {
        var params: [String : String]
        switch self {
        case .phoneNumberVertify(let phoneNumber):
            params = ["phone_number" : phoneNumber]
        case .nicknameVertify(let nickname):
            params = ["nickname" : nickname ]
        case .signIn(let phoneNumber, let deviceToken):
            params = [ "phone_number" : phoneNumber, "device_token" : deviceToken ]
        case .signUp(let nickname, let phoneNumber, let deviceToken):
            params = ["nickname" : nickname, "phone_number" : phoneNumber, "device_token" : deviceToken ]
        }
        return params.encode()
    }
    
    func getURL(path: String) -> String {
        let baseURL = URLs.baseURL
        switch self {
        case .phoneNumberVertify:
            return "\(baseURL)/auth/verification"
        case .nicknameVertify(let nickname):
            return "\(baseURL)/auth/nickname?nickname=\(nickname)"
        case .signIn:
            return "\(baseURL)/auth/login"
        case .signUp:
            return "\(baseURL)/auth/signup"
        }
    }
    
    func createRequest() -> NetworkRequest {
        let baseURL = URLs.baseURL
        
        switch self {
        case .phoneNumberVertify:
            var headers: [String: String] = [:]
            headers["Content-Type"] = "application/json"
            return NetworkRequest(url: getURL(path: baseURL),
                                  httpMethod: method,
                                  headers: headers,
                                  requestBody: body)
        case .nicknameVertify:
            var headers: [String: String] = [:]
            headers["Content-Type"] = "application/json"
            return NetworkRequest(url: getURL(path: baseURL),
                                  httpMethod: method,
                                  headers: headers)
        case .signIn:
            var headers: [String: String] = [:]
            headers["Content-Type"] = "application/json"
            return NetworkRequest(url: getURL(path: baseURL),
                                  httpMethod: method,
                                  headers: headers,
                                  requestBody: body)
        case .signUp:
            var headers: [String: String] = [:]
            headers["Content-Type"] = "application/json"
            return NetworkRequest(url: getURL(path: baseURL),
                                  httpMethod: method,
                                  headers: headers,
                                  requestBody: body)
        }
    }
}
