//
//  LoginViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/06.
//

import Foundation
import Combine

enum LoginPhase {
    case PhoneNumber
    case SMSCode
    case Nickname
}

protocol ViewModelType {
    associatedtype Input
    associatedtype Output

    func transform(loginPhase: LoginPhase, input: Input) -> Output
}

class VertificationViewModel: ViewModelType {

    struct Input {
        let vertifier: AnyPublisher<String, Never>
    }

    struct Output {
        let buttonIsValid: AnyPublisher<Bool, Never>
    }

    func transform(loginPhase: LoginPhase, input: Input) -> Output {
        let buttonStatePublisher = input.vertifier.map { vertifier in
            vertifier.count > 0
        }.eraseToAnyPublisher()
        return Output(buttonIsValid: buttonStatePublisher)
    }
}
