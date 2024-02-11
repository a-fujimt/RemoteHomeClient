//
//  OperationListViewModel.swift
//  RemoteHome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

class OperationListViewModel: ObservableObject {
    
    let client = ConcurrncyApiClient()
    let appliance: Appliance
    @Published var operations: [Operation] = []
    @Published var isShowingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
    
    @MainActor
    func fetch() async {
        let result = await client.fetchOperationList(appliance: appliance.id)
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
            self.operations = []
            self.isShowingAlert = true
            self.alertTitle = "Error"
            self.alertMessage = message
        }
    }
    
    @MainActor
    func send(operation: String) async {
        let result = await client.postOperation(appliance: appliance.id, operation: operation)
        switch result {
        case .success(_):
            self.isShowingAlert = true
            self.alertTitle = "Success!"
            self.alertMessage = ""
        case let .failure(error):
            let message: String
            if let apiError = error as? ApiError {
                message = apiError.getErrorDetail()
            } else {
                message = "Error"
                self.isShowingAlert = true
                self.alertTitle = "Error"
                self.alertMessage = message
            }
        }
    }
    
}
