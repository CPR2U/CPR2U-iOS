//
//  TestViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/22.
//

import UIKit

//class TestViewController: UIViewController {
//
//    private let educationManager = EducationManager(service: APIManager())
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        Task {
//            let result1 = try await educationManager.saveQuizResult(score: 100)
//            await print("RESULT 1 ", result1.0)
//            await print("RESULT 1 ", result1.1)
//            let result2 = try await educationManager.saveLectureProgress(lectureId: 1)
//            await print("RESULT 2 ", result2.0)
//            await print("RESULT 2 ", result2.1)
//            let result3 = try await educationManager.savePosturePracticeResult(score: 100)
//            await print("RESULT 3 ", result3.0)
//            await print("RESULT 3 ", result3.1)
//            let result4 = try await educationManager.getEducationProgress()
//            await print("RESULT 4 ", result4.0)
//            await print("RESULT 4 ", result4.1)
//            let result5 = try await educationManager.getQuizList()
//            await print("RESULT 5 ", result5.0)
//            await print("RESULT 5 ", result5.1)
//            let result6 = try await educationManager.getLecture()
//            await print("RESULT 6 ", result6.0)
//            await print("RESULT 6 ", result6.1)
//            let result7 = try await educationManager.getPostureLecture()
//            await print("RESULT 7 ", result7.1)
//        }
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
