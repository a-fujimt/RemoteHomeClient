//
//  ApiError.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

struct ApiError: Decodable {
    var error: ApiErrorMessage
}

struct ApiErrorMessage: Decodable {
    var message: String
}
