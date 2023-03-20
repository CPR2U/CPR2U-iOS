//
//  PosePracticeViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit
import os

enum Constants {
    // Configs for the TFLite interpreter.
    static let defaultThreadCount = 4
    static let defaultDelegate: Delegates = .gpu
    static let defaultModelType: ModelType = .movenetThunder
    
    // Minimum score to render the result.
    static let minimumScore: Float32 = 0.2
}

final class PosePracticeViewController: UIViewController {

    private let timeImageView = UIImageView()
    private let timeLabel = UILabel()
    private let soundImageView = UIImageView()
    private let soundSwitch = UISwitch()
    
    private let quitButton = UIButton()
    
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
    var overlayImage: CameraOverlayView?
    
    // MARK: Controllers that manage functionality
    // Handles all data preprocessing and makes calls to run inference.
    private var poseEstimator: PoseEstimator?
    private var cameraFeedManager: CameraFeedManager!
    
    // Serial queue to control all tasks related to the TFLite model.
    let queue = DispatchQueue(label: "serial_queue")
    
    // Flag to make sure there's only one frame processed at each moment.
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOrientation()
        setUpConstraints()
        setUpStyle()
        setUpText()
        setUpAction()
        updateModel()
        configCameraCapture()
    }
    
    private func setUpOrientation() {
        UIApplication.shared.isIdleTimerDisabled = true
        
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = .landscapeRight
        }
        
        navigationController?.setNavigationBarHidden(true, animated: true)
        self.setNeedsUpdateOfSupportedInterfaceOrientations()
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        
        [
            overlayView,
            timeImageView,
            timeLabel,
            soundImageView,
            soundSwitch,
            quitButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            timeImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: make.space16),
            timeImageView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            timeImageView.widthAnchor.constraint(equalToConstant: 26),
            timeImageView.heightAnchor.constraint(equalToConstant: 26)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.leadingAnchor.constraint(equalTo: timeImageView.trailingAnchor, constant: make.space24),
            timeLabel.centerYAnchor.constraint(equalTo: timeImageView.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalToConstant: 64),
            timeLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            soundImageView.topAnchor.constraint(equalTo: timeImageView.bottomAnchor, constant: make.space16),
            soundImageView.leadingAnchor.constraint(equalTo: timeImageView.leadingAnchor),
            soundImageView.widthAnchor.constraint(equalToConstant: 30),
            soundImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            soundSwitch.leadingAnchor.constraint(equalTo: soundImageView.trailingAnchor, constant: make.space24),
            soundSwitch.centerYAnchor.constraint(equalTo: soundImageView.centerYAnchor),
            soundSwitch.widthAnchor.constraint(equalToConstant: 30),
            soundSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            quitButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -make.space4),
            quitButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space4),
            quitButton.widthAnchor.constraint(equalToConstant: 160),
            quitButton.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func setUpStyle() {
        let clockImgConfig = UIImage.SymbolConfiguration(pointSize: 26, weight: .regular, scale: .medium)
        timeImageView.image = UIImage(systemName: "clock", withConfiguration: clockImgConfig)
        let soundImgConfig = UIImage.SymbolConfiguration(pointSize: 29, weight: .regular, scale: .medium)
        soundImageView.image = UIImage(systemName: "metronome", withConfiguration: soundImgConfig)
        
        timeLabel.font = UIFont(weight: .bold, size: 24)
        timeLabel.textColor = .mainBlack
        
        quitButton.backgroundColor = .mainRed
        quitButton.layer.cornerRadius = 19
        quitButton.titleLabel?.font = UIFont(weight: .bold, size: 17)
        quitButton.setTitleColor(.mainWhite, for: .normal)
    }
    
    private func setUpText() {
        timeLabel.text = "01:53"
        quitButton.setTitle("QUIT", for: .normal)
    }
    
    private func setUpAction() {
        
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
extension PosePracticeViewController: CameraFeedManagerDelegate {
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
