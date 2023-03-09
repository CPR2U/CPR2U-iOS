//
//  EducationMainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/09.
//

import UIKit

final class EducationMainViewController: UIViewController {

    private let certificateStatusView = CertificateStatusView()
    private let progressView = EducationProgressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpStyle()
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        [
            certificateStatusView,
            progressView
        ].forEach({
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            certificateStatusView.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: make.space8),
            certificateStatusView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            certificateStatusView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            certificateStatusView.heightAnchor.constraint(equalToConstant: 64)
        ])
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: certificateStatusView.bottomAnchor, constant: make.space6),
            progressView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: make.space16),
            progressView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -make.space16),
            progressView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setUpStyle() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = true
        navBar.topItem?.title = "Education"
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed]
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
}
