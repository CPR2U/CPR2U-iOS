//
//  CallMainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/25.
//

import Combine
import GoogleMaps
import UIKit

final class CallMainViewController: UIViewController {

    private lazy var timeCounterView = {
        let view = TimeCounterView(viewModel: viewModel)
        return view
    }()
    private let currentLocationNoticeView = CurrentLocationNoticeView()
    private let callButton = CallCircleView()
    
    private let viewModel = CallViewModel()
    private var cancellables = Set<AnyCancellable>()
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocation()
        setUpConstraints()
        setUpStyle()
        setUpAction()
        bind(viewModel: viewModel)
    }

    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        
        [
            timeCounterView,
            currentLocationNoticeView,
            callButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            timeCounterView.topAnchor.constraint(equalTo: view.topAnchor),
            timeCounterView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            timeCounterView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            timeCounterView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            currentLocationNoticeView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: make.space16),
            currentLocationNoticeView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            currentLocationNoticeView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            currentLocationNoticeView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            callButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -make.space16),
            callButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            callButton.widthAnchor.constraint(equalToConstant: 80),
            callButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setUpStyle() {
        view.backgroundColor = .lightGray
    }
    
    private func setUpAction() {
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(didPressCallButton))
        recognizer.minimumPressDuration = 0.0
        callButton.addGestureRecognizer(recognizer)
        
    }
    
    private func setUpLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        let coor = locationManager.location?.coordinate
        
        let latitude = (coor?.latitude ?? 37.566508) as Double
        let longitude = (coor?.longitude ?? 126.977945) as Double
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
    }
    
    private func bind(viewModel: CallViewModel) {
        let output = viewModel.transform()
        
        output.isCalled.sink { isCalled in
            if isCalled {
                let vc = DispatchWaitViewController(viewModel: viewModel)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                self.callButton.cancelProgressAnimation()
                self.timeCounterView.cancelTimeCount()
            }
        }.store(in: &cancellables)
    }
    
    @objc func didPressCallButton(_ sender: UILongPressGestureRecognizer) {
        let state = sender.state
        
        if state == .began {
            callButton.progressAnimation()
            timeCounterView.timeCountAnimation()
        } else if state == .ended {
            callButton.cancelProgressAnimation()
            timeCounterView.cancelTimeCount()
        }
    }
    
}

extension CallMainViewController: CLLocationManagerDelegate {
    
}
