//
//  CustomNoticeView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

final class CustomNoticeView: UIView {

    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0.0
        
        noticeAppear()
        setUpConstraints()
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        [
            thumbnailImageView,
            titleLabel,
            subTitleLabel
        ].forEach({
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            thumbnailImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 95)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: make.space24),
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: make.space2),
            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            subTitleLabel.widthAnchor.constraint(equalToConstant: 264),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setUpLayout() {
        self.backgroundColor = UIColor(rgb: 0xFCFCFC)
        self.layer.cornerRadius = 20
        
        thumbnailImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont(weight: .bold, size: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .mainBlack
        subTitleLabel.font = UIFont(weight: .regular, size: 14)
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = .mainBlack
    }
    
    func setImage(uiImage: UIImage) {
        thumbnailImageView.image = uiImage
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func setSubTitle(subTitle: String) {
        subTitleLabel.text = subTitle
    }
    
    func isButtonExist(isExist: Bool) {
        self.heightAnchor.constraint(equalToConstant: isExist ? 308 : 230).isActive = true
        
        if isExist == true {
            setConfirmButton()
        } else {
            noticeDisappear(delay: 1.0)
        }
    }
    
    func setConfirmButton() {
        let confirmButton = UIButton()
        
        self.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26),
            confirmButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            confirmButton.widthAnchor.constraint(equalToConstant: 206),
            confirmButton.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        confirmButton.layer.cornerRadius = 22
        confirmButton.backgroundColor = .mainRed
        confirmButton.titleLabel?.font = UIFont(weight: .bold, size: 17)
        confirmButton.setTitleColor(.mainWhite, for: .normal)
        confirmButton.setTitle("CONFIRM", for: .normal)
        confirmButton.addTarget(self, action: #selector(didConfirmButtonTapped), for: .touchUpInside)
    }
    
    @objc private func didConfirmButtonTapped() {
        noticeDisappear(delay: 0)
    }
    
    private func noticeAppear() {
        self.superview?.isUserInteractionEnabled = false
        
        // 실제 적용 시 delay는 없을 예정
        UIView.animate(withDuration: 0.3, delay: 0.3, animations: {
            self.alpha = 1.0
        })
    }
                       
    func noticeDisappear(delay: CGFloat) {
        self.superview?.isUserInteractionEnabled = false
        UIView.animate(withDuration: 0.2, delay: delay, animations: {
            self.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.removeFromSuperview()
            self?.superview?.isUserInteractionEnabled = true
        })
    }
}
