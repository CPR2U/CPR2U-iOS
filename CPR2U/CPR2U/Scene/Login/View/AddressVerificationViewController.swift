//
//  AddressVerificationViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/05/24.
//

import Combine
import UIKit

final class AddressVerificationViewController: UIViewController {

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 24)
        label.textColor = .mainBlack
        label.text = "address_ins_txt".localized()
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .regular, size: 14)
        label.textColor = .mainBlack
        label.text = "address_des_txt".localized()
        return label
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(weight: .bold, size: 16)
        button.setTitle("continue".localized(), for: .normal)
        button.setTitleColor(.mainWhite, for: .normal)
        button.backgroundColor = .mainRed
        button.layer.cornerRadius = 27.5
        return button
    }()
    
    private var viewModel: AuthViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: AuthViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpConstraints()
        setUpStyle()
        bind(viewModel: viewModel)
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        let safeArea = view.safeAreaLayoutGuide
        
        [
            instructionLabel,
            descriptionLabel,
            continueButton
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            instructionLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: make.space16),
            instructionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            instructionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            instructionLabel.heightAnchor.constraint(equalToConstant: 32)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: instructionLabel.bottomAnchor, constant: make.space4),
            descriptionLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            descriptionLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: make.space16),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            continueButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            continueButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -make.space16),
            continueButton.heightAnchor.constraint(equalToConstant: 55)
        ])
        
    }
    
    private func setUpStyle() {
        view.backgroundColor = .white
    }
    
    private func bind(viewModel: AuthViewModel) {
        continueButton.tapPublisher.sink { [weak self] in
            Task {
                let signUpResult = try await self?.viewModel.signUp()
                if signUpResult == true {
                    self?.dismiss(animated: true)
                    let vc = TabBarViewController()
                    guard let window = self?.view.window else { return }
                    await window.setRootViewController(vc, animated: true)
                } else {
                    print("에러")
                }
            }
        }.store(in: &cancellables)
    }
}
