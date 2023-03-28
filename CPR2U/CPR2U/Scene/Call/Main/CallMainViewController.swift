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
    
    private let viewModel: CallViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: CallViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel: viewModel)
        setUpLocation()
        setUpConstraints()
        setUpStyle()
        setUpAction()
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
        // MARK: Location
        let location = viewModel.getLocation()
        let camera = GMSCameraPosition.camera(withLatitude: location.latitude, longitude: location.longitude, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        self.view.addSubview(mapView)
     
        // MARK: Location Text
        Task {
            let temp = try await GMSGeocoder().reverseGeocodeCoordinate(location)
            guard let refinedAddress = temp.results()?[0].lines?.joined() else { return }
            let idx = refinedAddress.firstIndex(of: " ")!
            let index = refinedAddress.distance(from: refinedAddress.startIndex, to: idx)
            let startIndex = refinedAddress.index(refinedAddress.startIndex, offsetBy: index)
            var address = "\(refinedAddress[startIndex...])"
            address.remove(at: address.startIndex)
            
            viewModel.setLocationAddress(str: address)
        }

        // MARK: Marker
        let marker = GMSMarker()
        marker.position = location
        marker.map = mapView
    }
    
    private func bind(viewModel: CallViewModel) {
        let output = viewModel.transform()
        
        output.isCalled.sink { isCalled in
            if isCalled {
                Task {
                    let testInfo = CallerLocationInfo(latitude: 125.5, longitude: 33.5, full_address: "jijiji")
                    try await viewModel.callDispatcher(callerLocationInfo: testInfo)
                    let vc = DispatchWaitViewController(viewModel: viewModel)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                    self.callButton.cancelProgressAnimation()
                    self.timeCounterView.cancelTimeCount()
                }
            }
        }.store(in: &cancellables)
        
        output.currentLocationAddress?.sink { address in
            self.currentLocationNoticeView.setUpLocationLabelText(as: address)
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
