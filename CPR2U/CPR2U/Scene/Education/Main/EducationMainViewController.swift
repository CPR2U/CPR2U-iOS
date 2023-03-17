//
//  EducationMainViewController.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/09.
//

import UIKit

final class EducationMainViewController: UIViewController {
    
    let eduName: [String] = ["Lecture" , "Quiz", "Pose Practice"]
    let eduDescription: [String] = ["Video lecture for CPR angel certificate", "Let’s check your CPR study", "Posture practice to get CPR angel certificate"]
    let eduStatus: [String] = ["Completed", "Not Completed", "Not Completed"]
    private let certificateStatusView = CertificateStatusView()
    private let progressView = EducationProgressView()
    private let educationCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpConstraints()
        setUpStyle()
        setUpCollectionView()
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
        view.backgroundColor = .mainWhite
        guard let navBar = self.navigationController?.navigationBar else { return }
        navBar.prefersLargeTitles = true
        navBar.topItem?.title = "Education"
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainRed]
        self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        
        educationCollectionView.backgroundColor = .mainWhite
        educationCollectionView.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    private func setUpCollectionView() {
        educationCollectionView.dataSource = self
        educationCollectionView.delegate = self
        educationCollectionView.register(EducationCollectionViewCell.self, forCellWithReuseIdentifier: EducationCollectionViewCell.identifier)
    }
}

extension EducationMainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eduName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EducationCollectionViewCell", for: indexPath) as! EducationCollectionViewCell
        
        cell.educationNameLabel.text = eduName[indexPath.row]
        cell.descriptionLabel.text = eduDescription[indexPath.row]
        cell.statusLabel.text = eduStatus[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let vc = navigateTo(index: index)
        navigationController?.pushViewController(vc, animated: true)
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
    
    func navigateTo(index: Int) -> UIViewController {
        var vc: UIViewController
        if index == 0 {
            vc = TestViewController()
        } else if index == 1 {
            vc = EducationQuizViewController()
        } else {
            vc = PracticeExplainViewController()
        }
        return vc
    }
}
