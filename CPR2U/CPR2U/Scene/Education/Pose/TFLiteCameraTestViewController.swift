//
//  TFLiteCameraTestViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/19.
//

import AVFoundation
import UIKit
import os

// TODO: Model 관련 설정하기
// TODO: FPS 설정
// TODO: etc 사항이 끝나면 본 코드부 PosePracticeViewController로 옮기기

enum Constants {
    // Configs for the TFLite interpreter.
    static let defaultThreadCount = 4
    static let defaultDelegate: Delegates = .gpu
    static let defaultModelType: ModelType = .movenetThunder
    
    // Minimum score to render the result.
    static let minimumScore: Float32 = 0.2
}

class TFLiteCameraTestViewController: UIViewController {
    private lazy var overlayView = CameraOverlayView()
    
    // MARK: Pose estimation model configs
    private var modelType: ModelType = Constants.defaultModelType
    private var threadCount: Int = Constants.defaultThreadCount
    private var delegate: Delegates = Constants.defaultDelegate
    private let minimumScore = Constants.minimumScore
    
    // MARK: Visualization
    // Relative location of `overlayView` to `previewView`.
    private var imageViewFrame: CGRect?
    // Input image overlaid with the detected keypoints.
//    var overlayImage: CameraOverlayView?
    
    // MARK: Controllers that manage functionality
    // Handles all data preprocessing and makes calls to run inference.
    private var poseEstimator: PoseEstimator?
    private var cameraFeedManager: CameraFeedManager!
    
    // Serial queue to control all tasks related to the TFLite model.
    let queue = DispatchQueue(label: "serial_queue")
    
    // Flag to make sure there's only one frame processed at each moment.
    var isRunning = false
    
    // MARK: View Handling Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.isIdleTimerDisabled = true
        setUpConstraints()
        updateModel()
        configCameraCapture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraFeedManager?.startRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraFeedManager?.stopRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageViewFrame = overlayView.frame
    }
    
    
    private func setUpConstraints() {
        view.addSubview(overlayView)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configCameraCapture() {
        cameraFeedManager = CameraFeedManager()
        cameraFeedManager.startRunning()
        cameraFeedManager.delegate = self
    }
    
    /// Call this method when there's change in pose estimation model config, including changing model
    /// or updating runtime config.
    private func updateModel() {
        // Update the model in the same serial queue with the inference logic to avoid race condition
        queue.async {
            do {
                self.poseEstimator = try MoveNet(
                    threadCount: self.threadCount,
                    delegate: self.delegate,
                    modelType: self.modelType)
            } catch let error {
                os_log("Error: %@", log: .default, type: .error, String(describing: error))
            }
        }
    }
}

// MARK: - CameraFeedManagerDelegate Methods
extension TFLiteCameraTestViewController: CameraFeedManagerDelegate {
    func cameraFeedManager(
        _ cameraFeedManager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer
    ) {
        self.runModel(pixelBuffer)
    }
    
    /// Run pose estimation on the input frame from the camera.
    private func runModel(_ pixelBuffer: CVPixelBuffer) {
        // Guard to make sure that there's only 1 frame process at each moment.
        guard !isRunning else { return }
        
        // Guard to make sure that the pose estimator is already initialized.
        guard let estimator = poseEstimator else { return }
        
        // Run inference on a serial queue to avoid race condition.
        queue.async {
            self.isRunning = true
            defer { self.isRunning = false }
            
            // Run pose estimation
            do {
                let (result, times) = try estimator.estimateSinglePose(
                    on: pixelBuffer)
                
                // Return to main thread to show detection results on the app UI.
                DispatchQueue.main.async {
//                    self.totalTimeLabel.text = String(format: "%.2fms",
//                                                      times.total * 1000)
//                    self.scoreLabel.text = String(format: "%.3f", result.score)
                    
                    // Allowed to set image and overlay
                    let image = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
                    // If score is too low, clear result remaining in the overlayView.
                    if result.score < self.minimumScore {
                        self.overlayView.image = image
                        return
                    }
                    
                    // Visualize the pose estimation result.
                    self.overlayView.draw(at: image, person: result)
                }
            } catch {
                os_log("Error running pose estimation.", type: .error)
                return
            }
        }
    }
}
