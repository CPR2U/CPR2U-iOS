//
//  LectureViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/24.
//

import Combine
import UIKit
import WebKit

final class LectureViewController: UIViewController {
    
    private var viewModel: EducationViewModel
    private var cancellables = Set<AnyCancellable>()
    private let webView = WKWebView()
    
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
        loadWebPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
        ])
    }
    
    private func setUpStyle() {
        view.backgroundColor = .white
    }
    
    private func loadWebPage() {
        Task {
//            guard let url = try await viewModel.getLecture() else { return }
//            guard let stringToURL = URL(string: url) else { return }
            guard let stringToURL = URL(string: "http://naver.com") else { return }
            let URLToRequest = URLRequest(url: stringToURL)
            webView.load(URLToRequest)
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
}
