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
    case timeOut
    case wrongUrl
    case unknown(Error)
}

extension ApiError {
    
    func getErrorDetail() -> String {
        switch self {
        case let .server(status, message):
            return message + "(" + String(status) + ")"
        case .decoder(_):
            return "decode error"
        case .noResponse:
            return "No response"
        case .timeOut:
            return "Time out"
        case .wrongUrl:
            return "Wrong URL"
        case .unknown(_):
            return "Unknown error"
        }
    }
    
}
