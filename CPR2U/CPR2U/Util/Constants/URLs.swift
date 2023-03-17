//
//  URLs.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/11.
//

import Foundation

class URLs {
    static var baseURL: String = {
        guard let privatePlist = Bundle.main.url(forResource: "Private", withExtension: "plist"), let dictionary = NSDictionary(contentsOf: privatePlist), let link: String = dictionary["hlsLink"] as? String else { return "" }
        
        return link
    }()

}
