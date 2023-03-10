//
//  NoticeTestViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//  MARK: TEST VIEW CONTROLLER

import UIKit

class NoticeTestViewController: UIViewController {

    private let noticeView = CustomNoticeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.addSubview(noticeView)
        noticeView.translatesAutoresizingMaskIntoConstraints = false

        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            noticeView.topAnchor.constraint(equalTo: view.topAnchor),
            noticeView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            noticeView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noticeView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
//        noticeView.setNotice(as: .quiz)
        noticeView.setNotice(as: .certificate)
    }
}
