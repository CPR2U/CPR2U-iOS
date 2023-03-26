//
//  TestViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/22.
//

import UIKit

class TestViewController: UIViewController {

    private let callManager = CallManager(service: APIManager())
    override func viewDidLoad() {
        super.viewDidLoad()

        Task {
            let result1 = try await callManager.getCallerList()
            print("RESULT 1 ", result1.success)
            print("RESULT 1 ", result1.data)
            
            let result3 = try await callManager.situationEnd(callId: 13)
            await print("RESULT 3 ", result3.0)
            await print("RESULT 3 ", result3.1)
            
            let info = CallerLocationInfo(latitude: 12.45, longitude: 14.55, fullAddress: "ejifjeijfie")
            let result2 = try await callManager.callDispatcher(callerLocationInfo: info)
            print("RESULT 2 ", result2.0)
            print("RESULT 2 ", result2.1)
            
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
