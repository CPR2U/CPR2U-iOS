//
//  String+.swift
//  CPR2U
//
//  Created by 황정현 on 2023/05/11.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
