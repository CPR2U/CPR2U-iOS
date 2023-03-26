//
//  CallViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/26.
//

import Combine
import Foundation

final class CallViewModel: OutputOnlyViewModelType {
    private var callManager: CallManager
    var timer: Timer.TimerPublisher?
    private let iscalled = CurrentValueSubject<Bool, Never>(false)
    
    init() {
        callManager = CallManager(service: APIManager())
    }
    
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
    
    func receiveCallerList() async throws -> CallerListInfo? {
        let result = Task { () -> CallerListInfo? in
            let callResult = try await callManager.getCallerList()
            
            guard let list = callResult.data else { return nil }
            return list
        }
        return try await result.value
    }
    
    func callDispatcher(callerLocationInfo: CallerLocationInfo) async throws -> CallResult? {
        let result = Task { () -> CallResult? in
            let callResult = try await callManager.callDispatcher(callerLocationInfo: callerLocationInfo)
            
            guard let id = callResult.data else { return nil }
            return id
        }
        return try await result.value
    }
    
    func situationEnd(callId: Int) async throws {
        Task {
            try await callManager.situationEnd(callId: callId)
        }
    }
}
