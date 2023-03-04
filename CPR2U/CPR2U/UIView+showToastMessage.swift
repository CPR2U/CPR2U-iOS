//
//  UIView+showToastMessage.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/04.
//

import UIKit

extension UIView {
    
    func showToastMessage(nickname: String) {
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let toastLabel = UILabel()
        
        let margin = 8
        
        toastLabel.frame = CGRect(x: margin, y: Int(height * 0.88), width: Int(width) - margin * 2, height: 45)

        toastLabel.font = UIFont(weight: .bold, size: 14)
        toastLabel.text = "‘\(nickname)’ is Available"
        toastLabel.textColor = .mainWhite
        toastLabel.backgroundColor = .mainBlack
        toastLabel.textAlignment = .center
        toastLabel.layer.cornerRadius = 8
        toastLabel.clipsToBounds = true
        toastLabel.isUserInteractionEnabled = false
        toastLabel.layer.opacity = 0
        self.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            toastLabel.layer.opacity = 1.0
        }, completion: {_ in
            UIView.animate(withDuration: 0.5, delay: 0.8, options: .curveEaseOut, animations: {
                toastLabel.layer.opacity = 0
            }, completion: {_ in
                toastLabel.removeFromSuperview()
            })
        })
    }
    
}

