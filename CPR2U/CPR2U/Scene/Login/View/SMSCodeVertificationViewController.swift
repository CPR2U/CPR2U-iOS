//
//  SMSCodeVerificationViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/04.
//

import Combine
import UIKit

final class SMSCodeVerificationViewController: UIViewController {
    
    private let signManager = SignManager(service: APIManager())
    
    private let instructionLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    var phoneNumberString: String?
    var smsCode: String?
    
    private let phoneNumberLabel = UILabel()
    
    private let smsCodeInputView1 = SMSCodeInputView()
    private let smsCodeInputView2 = SMSCodeInputView()
    private let smsCodeInputView3 = SMSCodeInputView()
    private let smsCodeInputView4 = SMSCodeInputView()
    
    private let codeResendLabel = UILabel()
    
    private let confirmButton = UIButton()
    
    private var confirmButtonBottomConstraints = NSLayoutConstraint()
    
    private var smsCodeCheckArr = Array(repeating: false, count: 4) {
        willSet(newValue) {
            let status = newValue.allSatisfy({$0})
            confirmButton.setTitleColor(status ? .mainWhite : .mainBlack, for: .normal)
            confirmButton.backgroundColor = status ? .mainRed : .mainLightGray
            confirmButton.isUserInteractionEnabled = status
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init(phoneNumberString: String, smsCode: String) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumberString = phoneNumberString
        self.smsCode = smsCode
        print("SMS CODE: ", smsCode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpStyle()
        setUpText()
        setUpLayerName()
        setUpDelegate()
        setUpAction()
        setUpKeyboard()
        bind()
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
        
        confirmButtonBottomConstraints = confirmButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -space16)
        NSLayoutConstraint.activate([
            confirmButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            confirmButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            confirmButtonBottomConstraints,
            confirmButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setUpStyle() {
        
        view.backgroundColor = .white
        
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
        confirmButton.setTitleColor(.mainBlack, for: .normal)
        confirmButton.backgroundColor = .mainLightGray
        confirmButton.layer.cornerRadius = 27.5
        confirmButton.isUserInteractionEnabled = false
    }
    
    private func setUpText() {
        instructionLabel.text = "Enter Code"
        descriptionLabel.text = "An SMS code was sent to"
        
        phoneNumberLabel.text = phoneNumberString
        codeResendLabel.text = "Not receiveing the code?"
        confirmButton.setTitle("CONFIRM", for: .normal)
    }
    
    private func setUpLayerName() {
        let views = [smsCodeInputView1, smsCodeInputView2, smsCodeInputView3, smsCodeInputView4]
        for index in 0..<views.count {
            views[index].smsCodeTextField.layer.name = "\(index)"
        }
    }
    private func setUpDelegate() {
        [smsCodeInputView1, smsCodeInputView2, smsCodeInputView3, smsCodeInputView4].forEach({
            $0.smsCodeTextField.delegate = self
        })
    }
    
    private func setUpAction() {
        confirmButton.addTarget(self, action: #selector(navigateToNicknameVerificationPage), for: .touchUpInside)
    }
    
    private func setUpKeyboard() {
        smsCodeInputView1.smsCodeTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    private func bind() {
        let smsCodeViews = [smsCodeInputView1, smsCodeInputView2, smsCodeInputView3, smsCodeInputView4]
        
        for index in 0...3 {
            smsCodeViews[index].smsCodeTextField.textPublisher.sink {
                if $0.count == 1 {
                    if index != 3 {
                        smsCodeViews[(index+1)].smsCodeTextField.becomeFirstResponder()
                        smsCodeViews[(index+1)].smsCodeTextField.text = ""
                    }
                    self.smsCodeCheckArr[index] = true
                } else if $0.count > 1 && index == 3 {
                    smsCodeViews[(index)].smsCodeTextField.text?.removeFirst()
                }
            }
            .store(in: &cancellables)
        }
    }
    
    @objc func navigateToNicknameVerificationPage() {
        if smsCodeVerify() {
            userVerify()
        } else {
            print("인증코드 오류")
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            confirmButtonBottomConstraints.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        confirmButtonBottomConstraints.constant = -16
        view.layoutIfNeeded()
    }
}

extension SMSCodeVerificationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        guard let textFieldLayerName = textField.layer.name else { return }
        guard let index = Int(textFieldLayerName) else { return }
        self.smsCodeCheckArr[index] = false
        
    }
}

extension SMSCodeVerificationViewController {
    func smsCodeVerify() -> Bool {
        let userInput = [smsCodeInputView1, smsCodeInputView2, smsCodeInputView3, smsCodeInputView4]
            .compactMap{$0.smsCodeTextField.text}
            .reduce("") { return $0 + $1 }
        return userInput == smsCode
    }
    
    func userVerify() {
        Task {
            guard let phoneNumber = phoneNumberString else { return }
            let result = try await signManager.signIn(phoneNumber: phoneNumber, deviceToken: "")
            if result.success == false {
                guard let phoneNumberString = phoneNumberString else { return }
                navigationController?.pushViewController(NicknameVerificationViewController(phoneNumberString: phoneNumberString), animated: true)
            } else {
                dismiss(animated: true)
            }
        }
    }
}
