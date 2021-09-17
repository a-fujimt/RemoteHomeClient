//
//  OperationListViewModel.swift
//  RemoteHome
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
                DispatchQueue.main.async {
                    self.operations = []
                }
                let message: String
                if let apiError = error as? ApiError {
                    message = apiError.getErrorDetail()
                } else {
                    message = "Error"
                }
                completion(("Error", message))
            }
        }
    }
    
    func send(operation: String, completion: @escaping ((String, String)) -> Void) {
        client.postOperation(appliance: appliance.id, operation: operation, completion: { result in
            switch result {
            case .success(_):
                completion(("Success!", ""))
            case let .failure(error):
                let message: String
                if let apiError = error as? ApiError {
                    message = apiError.getErrorDetail()
                } else {
                    message = "Error"
                }
                completion(("Error", message))
            }
        })
    }
}
