//
//  CallMainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/25.
//

import UIKit

final class CallMainViewController: UIViewController {

    private let timeCounterView = TimeCounterView()
    private let currentLocationNoticeView = CurrentLocationNoticeView()
    private let callButton = CallCircleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    @objc func didPressCallButton(_ sender: UILongPressGestureRecognizer) {
        let state = sender.state
        
        if state == .began {
            callButton.progressAnimation()
            timeCounterView.timeCountAnimation()
        } else if state == .ended {
            callButton.cancelProgressAnimation()
            timeCounterView.cancelTimeCount()
        }
//        switch state {
//        case .possible:
//            <#code#>
//        case .began:
//            <#code#>
//        case .changed:
//            <#code#>
//        case .ended:
//            <#code#>
//        case .cancelled:
//            <#code#>
//        case .failed:
//            <#code#>
//        case .recognized:
//            <#code#>
//        }
    }
                                                   
}
