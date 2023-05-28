//
//  PoseAvailabilityCheckView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/05/24.
//

import UIKit

final class PoseAvailabilityCheckView: UIView {

    private let instructionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(weight: .bold, size: 42)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.textColor = .mainRed
        label.text = "pe_ins_txt".localized()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        self.addSubview(instructionLabel)
        instructionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            instructionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: make.space16),
            instructionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -make.space16),
            instructionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            instructionLabel.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    private func setUpStyle() {
        self.backgroundColor = .white.withAlphaComponent(0.5)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        })
    }
}
