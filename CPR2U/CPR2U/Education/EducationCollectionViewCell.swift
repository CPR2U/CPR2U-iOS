//
//  EducationCollectionViewCell.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class EducationCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "EducationCollectionViewCell"
    
    let educationNameLabel = UILabel()
    let descriptionLabel = UILabel()
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
        setUpLayout()
        setUpText()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        
        let make = Constraints.shared
        
        [
            educationNameLabel,
            descriptionLabel,
            statusLabel
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            educationNameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: make.space10),
            educationNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: make.space20),
            educationNameLabel.widthAnchor.constraint(equalToConstant: 160),
            educationNameLabel.heightAnchor.constraint(equalToConstant: 18),
            
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: educationNameLabel.bottomAnchor, constant: make.space2),
            descriptionLabel.leadingAnchor.constraint(equalTo: educationNameLabel.leadingAnchor),
            educationNameLabel.widthAnchor.constraint(equalToConstant: 160),
            educationNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -make.space18),
            statusLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -make.space14)
        ])
        
    }
    
    private func setUpLayout() {
        self.backgroundColor = .mainLightRed
        self.layer.cornerRadius = 20
        
        educationNameLabel.font = UIFont(weight: .bold, size: 16)
        descriptionLabel.font = UIFont(weight: .regular, size: 12)
        statusLabel.font = UIFont(weight: .bold, size: 16)
        
        educationNameLabel.textColor = .mainBlack
        descriptionLabel.textColor = .mainBlack
        statusLabel.textColor = .mainRed
        
    }
    
    private func setUpText() {
        educationNameLabel.text = "Lecture"
        descriptionLabel.text = "Video lecture for CPR angel certificate"
        statusLabel.text = "Completed"
    }

}
