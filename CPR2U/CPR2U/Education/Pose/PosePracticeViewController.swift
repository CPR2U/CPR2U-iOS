//
//  PosePracticeViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class PosePracticeViewController: UIViewController {

    private let timeImageView = UIImageView()
    private let timeLabel = UILabel()
    private let soundImageView = UIImageView()
    private let soundSwitch = UISwitch()
    
    private let quitButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpOrientation()
        setUpConstraints()
        setUpLayout()
        setUpText()
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
    }
    
    private func setUpLayout() {
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
}
