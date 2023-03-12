//
//  NicknameVertificationViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

enum NicknameStatus {
    case specialCharacters
    case unavailable
    case available
    case none
    
    func changeNoticeLabel(noticeLabel: UILabel, nickname: String?) {
        
        let name = nickname ?? ""
        var str: String
        switch self {
        case .specialCharacters:
            str = "Nickname cannot contain special characters"
        case .unavailable:
            str = "\'\(name)' is Unavailable"
        case .available:
            str = ""
        case .none:
            str = ""
        }
        
        noticeLabel.text = str
        
    }
    
    func changeNoticeViewLayerBorderColor(view: UIView) {
        if self == .unavailable {
            view.layer.borderColor = UIColor.mainRed.cgColor
        } else {
            view.layer.borderColor = UIColor(rgb:0xF2F2F2).cgColor
        }
    }
}

final class NicknameVertificationViewController: UIViewController {

    private let signAPI = SignManager(service: APIManager())
    
    var phoneNumberString: String?
    
    private let instructionLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let nicknameView = UIView()
    private let nicknameTextField = UITextField()
    
    private let irregularNoticeLabel = UILabel()
    
    private let continueButton = UIButton()
    
    private var continueButtonBottomConstraints = NSLayoutConstraint()
    
    private var availableNickname = ""
    private var nicknameStatus: NicknameStatus = NicknameStatus.none {
        willSet(newValue) {
            newValue.changeNoticeLabel(noticeLabel: irregularNoticeLabel, nickname: nicknameTextField.text)
            newValue.changeNoticeViewLayerBorderColor(view: nicknameView)
        }
    }
    
    init(phoneNumberString: String) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumberString = phoneNumberString
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        setUpStyle()
        setUpText()
        setUpAction()
        setUpKeyboard()
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
        
        continueButtonBottomConstraints = continueButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -space16)
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: space16),
            continueButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -space16),
            continueButtonBottomConstraints,
            continueButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
    
    private func setUpStyle() {
        
        view.backgroundColor = .white
        
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
        
        continueButton.titleLabel?.font = UIFont(weight: .bold, size: 16)
        continueButton.setTitleColor(.mainWhite, for: .normal)
        continueButton.backgroundColor = .mainRed
        continueButton.layer.cornerRadius = 27.5
    }
    
    private func setUpText() {
        instructionLabel.text = "Enter your Nickname"
        descriptionLabel.text = "People can recognize you by your nickname"
        continueButton.setTitle("CONTINUE", for: .normal)
        
        nicknameTextField.placeholder = "Nickname*"
    }
    
    private func setUpAction() {
        nicknameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        continueButton.addTarget(self, action: #selector(continueButtonDidTap), for: .touchUpInside)
    }
    
    private func setUpKeyboard() {
        nicknameTextField.becomeFirstResponder()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        hideKeyboardWhenTappedAround()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let str = textField.text else { return }
        
        if str.count > 20 {
            textField.text?.removeLast()
        }
        
        let strArr = Array(str)
        let pattern = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]$"
        
        if strArr.count > 0 {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                for index in 0..<strArr.count {
                    let checkString = regex.matches(in: String(strArr[index]), options: [], range: NSRange(location: 0, length: 1))
                    if checkString.count == 0 {
                        nicknameStatus = .specialCharacters
                        return
                    }
                }
            }
            nicknameStatus = .none
        } else {
            nicknameStatus = .none
        }
       
    }
    
    @objc func continueButtonDidTap() {
        guard let textCount = nicknameTextField.text?.count else { return }
        if (nicknameStatus != .specialCharacters && textCount != 0 ) {
            nicknameVerify()
        }
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height

            continueButtonBottomConstraints.constant = -keyboardHeight
            view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        continueButtonBottomConstraints.constant = -16
        view.layoutIfNeeded()
    }
}

extension NicknameVertificationViewController {
    func nicknameVerify() {
        Task {
            guard let userInput = nicknameTextField.text else { return }
            let result = try await signAPI.nicknameVerify(nickname: userInput)
            if result.success == false {
                nicknameStatus = .unavailable
            } else {
                nicknameStatus = .available
                signUp(nickname: userInput)
            }
        }
    }
    
    func signUp(nickname: String) {
        Task {
            guard let phoneNumber = phoneNumberString else { return }
            try await signAPI.signUp(nickname: nickname, phoneNumber: phoneNumber, deviceToken: "")
            dismiss(animated: true)
        }
    }
}
