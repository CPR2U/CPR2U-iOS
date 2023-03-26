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
    private var callId: Int?
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
        // MARK: TEST
        print("RECEIVE CALLER LIST")
        
        let result = Task { () -> CallerListInfo? in
            let callResult = try await callManager.getCallerList()
            
            guard let list = callResult.data else { return nil }
            return list
        }
        return try await result.value
    }
    
    func callDispatcher(callerLocationInfo: CallerLocationInfo) async throws {
        // MARK: TEST
        print("CALL DISPATCHER")
        updateCallId(callId: 24)
        
        Task {
            let callResult = try await callManager.callDispatcher(callerLocationInfo: callerLocationInfo)
            
            guard let data = callResult.data else { return }
            updateCallId(callId: data.call_id)
        }
    }
    
    func situationEnd() async throws {
        // MARK: TEST
        print("SITUATION END")
        guard let callId = callId else { return }
        
        Task {
            try await callManager.situationEnd(callId: callId)
        }
    }
    
    func updateCallId(callId: Int) {
        // MARK: TEST
        print("CALL ID UPDATED AS \(callId)")
        
        self.callId = callId
    }
}
