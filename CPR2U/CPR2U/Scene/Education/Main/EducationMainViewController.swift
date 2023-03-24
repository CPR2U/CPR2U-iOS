//
//  EducationMainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/09.
//

import Combine
import UIKit

protocol EducationMainViewControllerDelegate: AnyObject {
    func updateUserEducationStatus()
}

final class EducationMainViewController: UIViewController {

    private var certificateStatusView = CertificateStatusView()
    private let progressView = EducationProgressView()
    private let educationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private let viewModel = EducationViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    private weak var delegate: EducationMainViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpStyle()
        setUpCollectionView()
        Task {
            try await bind(to: viewModel)
        }
    }
    
    private func setUpConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        let make = Constraints.shared
        [
            certificateStatusView,
            progressView,
            educationCollectionView
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
        
        NSLayoutConstraint.activate([
            educationCollectionView.topAnchor.constraint(equalTo: progressView.bottomAnchor),
            educationCollectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            educationCollectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            educationCollectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])
    }
    
    private func setUpStyle() {
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = true
        navBar.topItem?.title = "Education"
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed]
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUpCollectionView() {
        educationCollectionView.dataSource = self
        educationCollectionView.delegate = self
        educationCollectionView.register(EducationCollectionViewCell.self, forCellWithReuseIdentifier: EducationCollectionViewCell.identifier)
    }
    
    private func bind(to viewModel: EducationViewModel) async throws {
        
        let output = try await viewModel.transform()
        
        output.certificateStatus?.sink { status in
            self.certificateStatusView.setUpStatus(as: status.status, leftDay: status.leftDay)
            print("HERE!")
        }.store(in: &cancellables)
        
        output.nickname?.sink { nickname in
            self.certificateStatusView.setUpGreetingLabel(nickname: nickname)
        }.store(in: &cancellables)
        
        output.progressPercent?.sink { progress in
            self.progressView.setUpProgress(as: progress)
        }.store(in: &cancellables)
    }
}

extension EducationMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.educationName().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EducationCollectionViewCell", for: indexPath) as! EducationCollectionViewCell
        
        cell.setUpEducationNameLabel(as: viewModel.educationName()[indexPath.row])
        cell.setUpDescriptionLabel(as: viewModel.educationDescription()[indexPath.row])
        cell.setUpStatus(isCompleted: viewModel.educationStatus()[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let isCompleted = index != 0 ? viewModel.educationStatus()[index - 1] : true
        if isCompleted == true {
            navigateTo(index: index)
        } else {
            view.showToastMessage(type: .education)
        }
        
    }
}

extension EducationMainViewController: UICollectionViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 358
    }
}

extension EducationMainViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return Constraints.shared.space16
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: 358, height: 108)
    }
    
    func navigateTo(index: Int) {
        var vc: UIViewController
        if index == 0 {
            vc = LectureViewController(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        } else if index == 1 {
            let temp = EducationQuizViewController()
            temp.delegate = self
            vc = UINavigationController(rootViewController: temp)
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
        } else {
            vc = PracticeExplainViewController(viewModel: viewModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension EducationMainViewController: EducationMainViewControllerDelegate {
    func updateUserEducationStatus() {
        Task {
            try await viewModel.receiveEducationStatus()
            view.layoutIfNeeded()
        }
    }
}
