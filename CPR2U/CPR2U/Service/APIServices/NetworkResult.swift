//
//  NetworkResult.swift
//  CPR2U
//
//  Created by 황정현 on 2023/03/12.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case decodeError
    case fail(T)
}
