//
//  CallViewModel.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/26.
//

import Combine
import Foundation
import GoogleMaps

final class CallViewModel: OutputOnlyViewModelType {
    @Published private(set)var callerListInfo: CallerListInfo?
    private var callManager: CallManager
    
    private var mapManager: MapManager
    private var currentLocation: CLLocationCoordinate2D?
    
    private var currentLocationAddress = CurrentValueSubject<String, Never>("Unable")
    
    private var callId: Int?
    private let iscalled = CurrentValueSubject<Bool, Never>(false)
    
    var timer: Timer.TimerPublisher?
    
    init() {
        callManager = CallManager(service: APIManager())
        mapManager = MapManager()
        receiveCallerList()
        setLocation()
    }
    
    struct Output {
        let isCalled: CurrentValueSubject<Bool, Never>
        let currentLocationAddress: CurrentValueSubject<String, Never>?
    }
    
    func transform() -> Output {
        return Output(isCalled: iscalled, currentLocationAddress: currentLocationAddress)
    }
    
    func isCallSucceed() {
        iscalled.send(true)
    }
    
    func cancelTimer() {
        timer?.connect().cancel()
    }
    
    func setLocation() {
        currentLocation = mapManager.setLocation()
    }
    
    func getLocation() -> CLLocationCoordinate2D {
        setLocation()
        guard let currentLocation = currentLocation else { return CLLocationCoordinate2D(latitude: 15, longitude: 15) }
        return currentLocation
    }

    func setLocationAddress(str: String) {
        currentLocationAddress.send(str)
    }
    
    func receiveCallerList() {
        Task {
            let callResult = try await callManager.getCallerList()
            
            guard let list = callResult.data else { return }
            callerListInfo = list
        }
    }
    
    func callDispatcher() async throws {
        Task {
            let address = self.currentLocationAddress.value
            let callerLocationInfo = CallerLocationInfo(latitude: getLocation().latitude, longitude: getLocation().longitude, full_address: address )
            let callResult = try await callManager.callDispatcher(callerLocationInfo: callerLocationInfo)
            guard let data = callResult.data else { return }
            updateCallId(callId: data.call_id)
        }
    }
    
    func situationEnd() async throws {
        guard let callId = callId else { return }
        
        Task {
            try await callManager.situationEnd(callId: callId)
        }
    }
    
    func countDispatcher() async throws -> Int? {
        guard let callId = callId else { return nil }
        
        let result = Task { () -> Int? in
            let callResult = try await callManager.countDispatcher(callId: callId)
            return callResult.data?.number_of_angels
        }
        
        return try await result.value
    }
    
    private func updateCallId(callId: Int) {
        self.callId = callId
    }
}
