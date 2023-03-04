//
//  SMSCodeVertificationViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

class SMSCodeVertificationViewController: UIViewController {

    private let instructionLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private var phoneNumberString: String?
    private let phoneNumberLabel = UILabel()
    
    private let smsCodeInputView1 = SMSCodeInputView()
    private let smsCodeInputView2 = SMSCodeInputView()
    private let smsCodeInputView3 = SMSCodeInputView()
    private let smsCodeInputView4 = SMSCodeInputView()
    
    private let codeResendLabel = UILabel()
    
    private let confirmButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        setUpStyle()
        setUpText()
    }
    
    private func setUpConstraints() {
        
        let space4: CGFloat = 4
        let space8: CGFloat = 8
        let space16: CGFloat = 16
        
        let safeArea = view.safeAreaLayoutGuide
        
        let smsCodeInputStackView   = UIStackView()
        smsCodeInputStackView.axis  = NSLayoutConstraint.Axis.horizontal
        smsCodeInputStackView.distribution  = UIStackView.Distribution.equalSpacing
        smsCodeInputStackView.alignment = UIStackView.Alignment.center
        smsCodeInputStackView.spacing   = 12
        
        [
            instructionLabel,
            descriptionLabel,
            phoneNumberLabel,
            smsCodeInputStackView,
            codeResendLabel,
            confirmButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
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
            descriptionLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        NSLayoutConstraint.activate([
            phoneNumberLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: space4),
            phoneNumberLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            phoneNumberLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            phoneNumberLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        self.view.addSubview(smsCodeInputStackView)
        smsCodeInputStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            smsCodeInputStackView.topAnchor.constraint(equalTo: phoneNumberLabel.bottomAnchor, constant: space16),
            smsCodeInputStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            smsCodeInputStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            smsCodeInputStackView.heightAnchor.constraint(equalToConstant: 54)
        ])
        
        [
            smsCodeInputView1,
            smsCodeInputView2,
            smsCodeInputView3,
            smsCodeInputView4
        ].forEach({
            $0.translatesAutoresizingMaskIntoConstraints = false
            smsCodeInputStackView.addArrangedSubview($0 as UIView)
            
            NSLayoutConstraint.activate([
                $0.topAnchor.constraint(equalTo: smsCodeInputStackView.topAnchor),
                $0.widthAnchor.constraint(equalToConstant: 76),
                $0.heightAnchor.constraint(equalToConstant: 54)
            ])
        })
        
        NSLayoutConstraint.activate([
            codeResendLabel.topAnchor.constraint(equalTo: smsCodeInputStackView.bottomAnchor, constant: space8),
            codeResendLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            codeResendLabel.widthAnchor.constraint(equalToConstant: 300),
            codeResendLabel.heightAnchor.constraint(equalToConstant: 24),
            
        ])
        
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            confirmButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            confirmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -space16),
            confirmButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setUpStyle() {
        instructionLabel.font = UIFont(weight: .bold, size: 24)
        instructionLabel.textColor = .mainBlack
        descriptionLabel.font = UIFont(weight: .regular, size: 14)
        descriptionLabel.textColor = .mainBlack
        
        phoneNumberLabel.font = UIFont(weight: .bold, size: 16)
        phoneNumberLabel.textAlignment = .left
        phoneNumberLabel.textColor = .mainBlack
        
        codeResendLabel.font = UIFont(weight: .regular, size: 14)
        codeResendLabel.textAlignment = .right
        codeResendLabel.textColor = .mainRed
        
        confirmButton.titleLabel?.font = UIFont(weight: .bold, size: 16)
        confirmButton.setTitleColor(.mainWhite, for: .normal)
        confirmButton.backgroundColor = .mainRed
        confirmButton.layer.cornerRadius = 27.5
    }
    
    private func setUpText() {
        instructionLabel.text = "Enter Code"
        descriptionLabel.text = "An SMS code was sent to"
        
        phoneNumberLabel.text = "+82 01012345678" //phoneNumberString
        
        codeResendLabel.text = "Not receiveing the code?"
        confirmButton.setTitle("CONFIRM", for: .normal)
    }

}
