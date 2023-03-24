//
//  PosePracticeViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import Combine
import os
import UIKit

enum Constants {
    // Configs for the TFLite interpreter.
    static let defaultThreadCount = 4
    static let defaultDelegate: Delegates = .gpu
    static let defaultModelType: ModelType = .movenetThunder
    
    // Minimum score to render the result.
    static let minimumScore: Float32 = 0.2
}

final class PosePracticeViewController: UIViewController {

    private let timeImageView: UIImageView = {
        let view = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .regular, scale: .medium)
        view.image = UIImage(systemName: "clock", withConfiguration: config)
        return view
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 24)
        label.textColor = .mainBlack
        
        // TEST
        label.text = "01:53"
        return label
    }()
    private let soundImageView: UIImageView = {
        let view = UIImageView()
        let config = UIImage.SymbolConfiguration(pointSize: 29, weight: .regular, scale: .medium)
        view.image = UIImage(systemName: "metronome", withConfiguration: config)
        return view
    }()
    private let soundSwitch = UISwitch()
    
    private let quitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainRed
        button.layer.cornerRadius = 19
        button.titleLabel?.font = UIFont(weight: .bold, size: 17)
        button.setTitleColor(.mainWhite, for: .normal)
        button.setTitle("QUIT", for: .normal)
        return button
    }()
    
    private lazy var overlayView = CameraOverlayView()
    
    // MARK: Pose estimation model configs
    private var modelType: ModelType = Constants.defaultModelType
    private var threadCount: Int = Constants.defaultThreadCount
    private var delegate: Delegates = Constants.defaultDelegate
    private let minimumScore = Constants.minimumScore
    
    // MARK: Visualization
    private var imageViewFrame: CGRect?
    
    // MARK: Controllers that manage functionality
    private var poseEstimator: PoseEstimator?
    private var cameraFeedManager: CameraFeedManager!
    
    private let queue = DispatchQueue(label: "serial_queue")
    private var isRunning = false
    
    private let viewModel: EducationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EducationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOrientation()
        setUpConstraints()
        updateModel()
        configCameraCapture()
        viewModel.updateTimerType(vc: self)
        setTimer()
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
    
    private func setTimer() {
        let count = viewModel.timeLimit()
        viewModel.timer
            .autoconnect()
            .scan(0) { counter, _ in counter + 1 }
            .sink { [self] counter in
                if counter == count {
                    cameraFeedManager.stopRunning()
                    // TEST
                    Task {
                        print("Times Up")
                        usleep(1000000)
                        let vc = PosePracticeResultViewController(viewModel: viewModel)
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true)
                    }
                    viewModel.timer.connect().cancel()
                }
            }.store(in: &cancellables)
    }
}

// MARK: - CameraFeedManagerDelegate Methods
extension PosePracticeViewController: CameraFeedManagerDelegate {
    func cameraFeedManager(
        _ cameraFeedManager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer
    ) {
        self.runModel(pixelBuffer)
    }
    
    private func runModel(_ pixelBuffer: CVPixelBuffer) {
        // Guard to make sure that there's only 1 frame process at each moment.
        guard !isRunning else { return }
        
        guard let estimator = poseEstimator else { return }
        
        queue.async {
            self.isRunning = true
            defer { self.isRunning = false }
            
            do {
                let (result, _) = try estimator.estimateSinglePose(
                    on: pixelBuffer)
                
                DispatchQueue.main.async {
                    let image = UIImage(ciImage: CIImage(cvPixelBuffer: pixelBuffer))
                    if result.score < self.minimumScore {
                        self.overlayView.image = image
                        return
                    }
                    
                    self.overlayView.draw(at: image, person: result)
                }
            } catch {
                os_log("Error running pose estimation.", type: .error)
                return
            }
        }
    }
}
