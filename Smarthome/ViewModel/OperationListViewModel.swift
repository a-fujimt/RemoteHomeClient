//
//  OperationListViewModel.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

class OperationListViewModel: ObservableObject {
    
    let client = ApiClient()
    let appliance: Appliance
    @Published var operations: [Operation] = []
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
    
    func fetch(completion: @escaping ((String, String)) -> Void) {
        client.fetchOperationList(appliance: appliance.id) { result in
            switch result {
            case let .success(operations):
                self.operations = operations
                completion(("Success!", ""))
            case let .failure(error):
                switch error {
                case let ApiError.server(status, message):
                    completion(("Error", message + "(" + String(status) + ")"))
                case ApiError.decoder(_):
                    completion(("Error", "decode error"))
                case ApiError.noResponse:
                    completion(("Error", "No response"))
                case ApiError.unknown(_):
                    completion(("Error", "Unknown error"))
                default:
                    completion(("Error", "Error"))
                }
            }
        }
    }
    
    func send(operation: String, completion: @escaping ((String, String)) -> Void) {
        client.postOperation(appliance: appliance.id, operation: operation, completion: { result in
            switch result {
            case .success(_):
                completion(("Success!", ""))
            case let .failure(error):
                switch error {
                case let ApiError.server(status, message):
                    completion(("Error", message + "(" + String(status) + ")"))
                case ApiError.decoder(_):
                    completion(("Error", "decode error"))
                case ApiError.noResponse:
                    completion(("Error", "No response"))
                case ApiError.unknown(_):
                    completion(("Error", "Unknown error"))
                default:
                    completion(("Error", "Error"))
                }
            }
        })
    }
}
