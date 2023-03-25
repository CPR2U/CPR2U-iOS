//
//  CallViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/26.
//

import Combine
import Foundation

final class CallViewModel: OutputOnlyViewModelType {
    var timer: Timer.TimerPublisher?
    private let iscalled = CurrentValueSubject<Bool, Never>(false)
    
    struct Output {
        let isCalled: CurrentValueSubject<Bool, Never>
    }
    
    func transform() -> Output {
        return Output(isCalled: iscalled)
    }
    
    func isCallSucceed() {
        iscalled.send(true)
    }
    
    func cancelTimer() {
        timer?.connect().cancel()
    }
}
