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
    @Published var isShowingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
    
    func fetch() {
        client.fetchOperationList(appliance: appliance.id) { result in
            switch result {
            case let .success(operations):
                self.operations = operations
            case let .failure(error):
                let message: String
                if let apiError = error as? ApiError {
                    message = apiError.getErrorDetail()
                } else {
                    message = "Error"
                }
                DispatchQueue.main.async {
                    self.operations = []
                    self.isShowingAlert = true
                    self.alertTitle = "Error"
                    self.alertMessage = message
                }
            }
        }
    }
    
    func send(operation: String) {
        client.postOperation(appliance: appliance.id, operation: operation) { result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self.isShowingAlert = true
                    self.alertTitle = "Success!"
                    self.alertMessage = ""
                }
            case let .failure(error):
                let message: String
                if let apiError = error as? ApiError {
                    message = apiError.getErrorDetail()
                } else {
                    message = "Error"
                }
                DispatchQueue.main.async {
                    self.isShowingAlert = true
                    self.alertTitle = "Error"
                    self.alertMessage = message
                }
            }
        }
    }
    
}
