//
//  MypageViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/31.
//

import Combine
import UIKit

final class MypageViewController: UIViewController {

    private lazy var mypageStatusView: MypageStatusView = {
        let view = MypageStatusView(viewModel: viewModel)
        return view
    }()

    private var statusViewBottomAnchor: NSLayoutConstraint?
    
    private var viewModel: EducationViewModel
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
        bind(viewModel: viewModel)
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        let safeArea = view.safeAreaLayoutGuide
        [
            mypageStatusView
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            mypageStatusView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: make.space18),
            mypageStatusView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mypageStatusView.widthAnchor.constraint(equalToConstant: 358),
            
        ])
    }
    
    private func setUpStyle() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = true
        navBar.topItem?.title = "Profile"
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bind(viewModel: EducationViewModel) {
        Task {
            let output = try await viewModel.transform()
            output.certificateStatus?.sink { [self] certificate in
                statusViewBottomAnchor = mypageStatusView.heightAnchor.constraint(equalToConstant: certificate
                    .status == .acquired ? 222 : 124)
                statusViewBottomAnchor?.isActive = true
                mypageStatusView.setUpStatusComponent(certificate: certificate)
                
            }.store(in: &cancellables)
            
            output.nickname?.sink { nickname in
                self.mypageStatusView.setUpGreetingLabel(nickname: nickname)
            }.store(in: &cancellables)
            
//            output.progressPercent?.sink { progress in
//                self.progressView.setUpProgress(as: progress)
//            }.store(in: &cancellables)
        }
    }
}
