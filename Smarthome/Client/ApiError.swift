//
//  ApiError.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

enum ApiError: Error {
    case server(Int, String)
    case decoder(Error)
    case noResponse
    case unknown(Error)
}
