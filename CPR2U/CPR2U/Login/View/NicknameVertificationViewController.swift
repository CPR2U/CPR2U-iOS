//
//  NicknameVertificationViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

final class NicknameVertificationViewController: UIViewController {

    private var isRegular = true {
        willSet(newValue) {
            if newValue == true {
                nicknameView.layer.borderColor = UIColor(rgb:0xF2F2F2).cgColor
                irregularNoticeLabel.isHidden = true
            } else {
                nicknameView.layer.borderColor = UIColor.mainRed.cgColor
                irregularNoticeLabel.isHidden = false
            }
        }
    }
    private let instructionLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let nicknameView = UIView()
    private let nicknameTextField = UITextField()
    
    private let irregularNoticeLabel = UILabel()
    private let availabilityCheckLabel = UILabel()
    
    private let continueButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        setUpStyle()
        setUpText()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.view.showToastMessage(nickname: "HeartBeatingS2")
        }
        
        
    }
    
    private func setUpConstraints() {
        
        let space4: CGFloat = 4
        let space8: CGFloat = 8
        let space16: CGFloat = 16
        
        let safeArea = view.safeAreaLayoutGuide
        
        [
            instructionLabel,
            descriptionLabel,
            nicknameView,
            irregularNoticeLabel,
            availabilityCheckLabel,
            continueButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        nicknameView.addSubview(nicknameTextField)
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: space16),
            instructionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            instructionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            instructionLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: space4),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: space16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28)
        ])

        NSLayoutConstraint.activate([
            nicknameView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: space8),
            nicknameView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            nicknameView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            nicknameView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            nicknameTextField.topAnchor.constraint(equalTo: nicknameView.topAnchor),
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameView.leadingAnchor, constant: space16),
            nicknameTextField.trailingAnchor.constraint(equalTo: nicknameView.trailingAnchor),
            nicknameTextField.heightAnchor.constraint(equalTo: nicknameView.heightAnchor)
        ])

        NSLayoutConstraint.activate([
            irregularNoticeLabel.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: space8),
            irregularNoticeLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            irregularNoticeLabel.widthAnchor.constraint(equalToConstant: 300),
            irregularNoticeLabel.heightAnchor.constraint(equalToConstant: 16),
        ])
        
        NSLayoutConstraint.activate([
            availabilityCheckLabel.topAnchor.constraint(equalTo: irregularNoticeLabel.bottomAnchor, constant: space4),
            availabilityCheckLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            availabilityCheckLabel.widthAnchor.constraint(equalToConstant: 300),
            availabilityCheckLabel.heightAnchor.constraint(equalToConstant: 20),
            
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            continueButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            continueButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -space16),
            continueButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setUpStyle() {
        instructionLabel.font = UIFont(weight: .bold, size: 24)
        instructionLabel.textColor = .mainBlack
        descriptionLabel.font = UIFont(weight: .regular, size: 14)
        descriptionLabel.textColor = .mainBlack
        
        nicknameView.layer.borderColor = UIColor(rgb:0xF2F2F2).cgColor
        nicknameView.layer.borderWidth = 1
        nicknameView.layer.cornerRadius = 6
        
        nicknameTextField.backgroundColor = .clear
        nicknameTextField.textColor = .mainBlack
        nicknameTextField.font = UIFont(weight: .regular, size: 16)
        
        irregularNoticeLabel.font = UIFont(weight: .regular, size: 14)
        irregularNoticeLabel.textAlignment = .left
        irregularNoticeLabel.textColor = .mainRed
        irregularNoticeLabel.isHidden = true
        
        availabilityCheckLabel.font = UIFont(weight: .regular, size: 14)
        availabilityCheckLabel.textAlignment = .right
        availabilityCheckLabel.textColor = .mainRed
        
        continueButton.titleLabel?.font = UIFont(weight: .bold, size: 16)
        continueButton.setTitleColor(.mainWhite, for: .normal)
        continueButton.backgroundColor = .mainRed
        continueButton.layer.cornerRadius = 27.5
    }
    
    private func setUpText() {
        instructionLabel.text = "Enter your Nickname"
        descriptionLabel.text = "People can recognize you by your nickname"
        
        nicknameTextField.placeholder = "Nickname*"
        
        irregularNoticeLabel.text = "Nickname cannot contain special characters"
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Check Availability", attributes: underlineAttribute)
        availabilityCheckLabel.attributedText = underlineAttributedString
        continueButton.setTitle("CONTINUE", for: .normal)
    }

}
