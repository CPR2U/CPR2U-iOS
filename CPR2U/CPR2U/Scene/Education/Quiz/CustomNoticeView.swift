//
//  CustomNoticeView.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/10.
//

import UIKit

enum Notice {
    case quiz
    case certificate
}

final class CustomNoticeView: UIView {

    private lazy var shadowView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(rgb: 0x7B7B7B).withAlphaComponent(0.45)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        return view
    } ()
    
    private let noticeView = UIView()
    private let thumbnailImageView = UIImageView()
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let appearAnimDuration: CGFloat = 0.4
    private let appearAnimDelay: CGFloat = 0.3

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.alpha = 0.0
        
        noticeAppear()
        setUpConstraints()
        setUpStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpConstraints() {
        let make = Constraints.shared
        
        self.addSubview(noticeView)
        noticeView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noticeView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            noticeView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            noticeView.widthAnchor.constraint(equalToConstant: 313)
        ])
        
        [
            thumbnailImageView,
            titleLabel,
            subTitleLabel
        ].forEach({
            noticeView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: noticeView.topAnchor, constant: 40),
            thumbnailImageView.leadingAnchor.constraint(equalTo: noticeView.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: noticeView.trailingAnchor),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 95)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: thumbnailImageView.bottomAnchor, constant: make.space24),
            titleLabel.centerXAnchor.constraint(equalTo: noticeView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: noticeView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: make.space2),
            subTitleLabel.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
            subTitleLabel.widthAnchor.constraint(equalToConstant: 264),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    private func setUpStyle() {
        self.backgroundColor = UIColor(rgb: 0x7B7B7B).withAlphaComponent(0.45)
        noticeView.backgroundColor = UIColor(rgb: 0xFCFCFC)
        noticeView.layer.cornerRadius = 20
        
        thumbnailImageView.contentMode = .scaleAspectFit
        
        titleLabel.font = UIFont(weight: .bold, size: 18)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .mainBlack
        subTitleLabel.font = UIFont(weight: .regular, size: 14)
        subTitleLabel.textAlignment = .center
        subTitleLabel.textColor = .mainBlack
    }
    
    func setNotice(as notice: Notice) {
        setTitle(title: "Congratulation!")
        switch notice {
        case .quiz:
            guard let image = UIImage(named: "success_heart.png") else { return }
            setImage(uiImage: image)
            setSubTitle(subTitle: "You are perfect!")
            isButtonExist(isExist: true)
        case .certificate:
            guard let image = UIImage(named: "certificate_big.png") else { return }
            setImage(uiImage: image)
            setSubTitle(subTitle: "You have got CPR Angel Certificate!")
            isButtonExist(isExist: false)
        }
    }
    
    private func setImage(uiImage: UIImage) {
        thumbnailImageView.image = uiImage
    }
    
    private func setTitle(title: String) {
        titleLabel.text = title
    }
    
    private func setSubTitle(subTitle: String) {
        subTitleLabel.text = subTitle
    }
    
    private func isButtonExist(isExist: Bool) {
        noticeView.heightAnchor.constraint(equalToConstant: isExist ? 308 : 240).isActive = true
        
        if isExist == true {
            setConfirmButton()
        } else {
            noticeDisappear(delay: appearAnimDelay + appearAnimDuration + 0.5)
        }
    }
    
    private func setConfirmButton() {
        let confirmButton = UIButton()
        
        self.addSubview(confirmButton)
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            confirmButton.bottomAnchor.constraint(equalTo: noticeView.bottomAnchor, constant: -26),
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
        UIView.animate(withDuration: appearAnimDuration, delay: appearAnimDelay, animations: {
            self.alpha = 1.0
        })
    }
                       
    private func noticeDisappear(delay: CGFloat) {
        UIView.animate(withDuration: appearAnimDuration/2, delay: delay, animations: {
            self.alpha = 0.0
        }, completion: { [weak self] _ in
            self?.superview?.isUserInteractionEnabled = true
            self?.removeFromSuperview()
        })
    }
}
