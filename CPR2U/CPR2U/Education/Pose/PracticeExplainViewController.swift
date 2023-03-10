//
//  PracticeExplainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class PracticeExplainViewController: UIViewController {
    
    // temp: 추후 비디오가 삽입될 영역
    private lazy var temp: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let moveButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpLayout()
        setUpText()
        setUpAction()
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide

        [
            temp,
            moveButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            temp.topAnchor.constraint(equalTo: safeArea.topAnchor),
            temp.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            temp.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            temp.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            moveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            moveButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            moveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            moveButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setUpLayout() {
        moveButton.backgroundColor = .mainLightRed
        moveButton.setTitleColor(.mainBlack, for: .normal)
        moveButton.titleLabel?.font = UIFont(weight: .bold, size: 16)
    }
    
    private func setUpText() {
        moveButton.setTitle("Moving on to Posture Practice", for: .normal)
    }
    
    private func setUpAction() {
        
    }
}
