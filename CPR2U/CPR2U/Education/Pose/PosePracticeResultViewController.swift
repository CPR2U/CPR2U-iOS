//
//  PosePracticeResultViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class PosePracticeResultViewController: UIViewController {

    private let compressRateResultView = EvaluationResultView()
    private let pressDepthResultView = EvaluationResultView()
    private let handLocationResultView = EvaluationResultView()
    private let armAngleResultView = EvaluationResultView()
    private let finalResultView = AccuracyResultView()
    
    private let quitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpOrientation()
        setUpConstraints()
        setUpStyle()
        setUpResultViews()
        setUpAction()
    }
    
    private func setUpOrientation() {
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
            compressRateResultView,
            pressDepthResultView,
            handLocationResultView,
            armAngleResultView,
            finalResultView,
            quitButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        let evaluationResultViewArr = [compressRateResultView, pressDepthResultView, handLocationResultView, armAngleResultView,]
        
        evaluationResultViewArr.forEach({
            $0.widthAnchor.constraint(equalToConstant: 255).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 150).isActive = true
        })
        
        NSLayoutConstraint.activate([
            compressRateResultView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: make.space24),
            compressRateResultView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16)
        ])
        
        NSLayoutConstraint.activate([
            pressDepthResultView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -make.space24),
            pressDepthResultView.leadingAnchor.constraint(equalTo: compressRateResultView.leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            handLocationResultView.topAnchor.constraint(equalTo: compressRateResultView.topAnchor),
            handLocationResultView.leadingAnchor.constraint(equalTo: compressRateResultView.trailingAnchor, constant: make.space16)
        ])
        
        NSLayoutConstraint.activate([
            armAngleResultView.bottomAnchor.constraint(equalTo: pressDepthResultView.bottomAnchor),
            armAngleResultView.leadingAnchor.constraint(equalTo: compressRateResultView.trailingAnchor, constant: make.space16)
        ])
        
        NSLayoutConstraint.activate([
            quitButton.bottomAnchor.constraint(equalTo: armAngleResultView.bottomAnchor),
            quitButton.leadingAnchor.constraint(equalTo: armAngleResultView.trailingAnchor, constant: make.space16),
            quitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -make.space16),
            quitButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            finalResultView.topAnchor.constraint(equalTo: handLocationResultView.topAnchor),
            finalResultView.bottomAnchor.constraint(equalTo: quitButton.topAnchor, constant: -make.space12),
            finalResultView.leadingAnchor.constraint(equalTo: quitButton.leadingAnchor),
            finalResultView.trailingAnchor.constraint(equalTo: quitButton.trailingAnchor)
            
        ])
    }
    
    private func setUpStyle() {
        quitButton.backgroundColor = .mainRed
        quitButton.layer.cornerRadius = 19
        quitButton.titleLabel?.font = UIFont(weight: .bold, size: 17)
        quitButton.setTitleColor(.mainWhite, for: .normal)
        quitButton.setTitle("QUIT", for: .normal)
    }
    
    private func setUpResultViews() {
        
        compressRateResultView.setImage(imgName: "ruler")
        compressRateResultView.setTitle(title: "Compression Rate")
        compressRateResultView.setResultLabelText(as: "0.5 per 1 time")
        compressRateResultView.setDescriptionLabelText(as: "It’s too fast. Little bit Slower")
        
        pressDepthResultView.setImage(imgName: "ruler")
        pressDepthResultView.setTitle(title: "Press Depth")
        pressDepthResultView.setResultLabelText(as: "Slightly shallow")
        pressDepthResultView.setDescriptionLabelText(as: "Press little deeper")
        
        handLocationResultView.setImage(imgName: "ruler")
        handLocationResultView.setTitle(title: "Hand Location")
        handLocationResultView.setResultLabelText(as: "Adequate")
        handLocationResultView.setDescriptionLabelText(as: "Nice Location!")
        
        armAngleResultView.setImage(imgName: "ruler")
        armAngleResultView.setTitle(title: "Arm Angle")
        armAngleResultView.setResultLabelText(as: "Adequate")
        armAngleResultView.setDescriptionLabelText(as: "Nice Angle!")
    }
    
    private func setUpAction() {
        
    }

}
