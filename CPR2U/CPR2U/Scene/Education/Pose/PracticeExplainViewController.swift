//
//  PracticeExplainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import Combine
import CombineCocoa
import UIKit

final class PracticeExplainViewController: UIViewController {
    
    // temp: 추후 설명용 이미지가 삽입될 영역
    private lazy var temp: UIView = {
        let view = UIView()
        return view
    }()
    
    private let moveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainLightRed
        button.setTitleColor(.mainBlack, for: .normal)
        button.titleLabel?.font = UIFont(weight: .bold, size: 16)
        button.setTitle("Moving on to Posture Practice", for: .normal)
        return button
    }()
    
    private let viewModel: EducationViewModel
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: EducationViewModel) {
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
        setUpAction()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
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
            moveButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            moveButton.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            moveButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            moveButton.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setUpStyle() {
        view.backgroundColor = .white
    }
    
    private func setUpAction() {
        moveButton.tapPublisher.sink { [self] in
            setUpOrientation(as: .landscapeRight)
            let vc = PosePracticeViewController(viewModel: viewModel)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        }.store(in: &cancellables)
    }
}
