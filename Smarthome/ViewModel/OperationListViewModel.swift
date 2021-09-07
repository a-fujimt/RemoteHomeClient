//
//  OperationListViewModel.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

class OperationListViewModel: ObservableObject {
    
    let fetcher = OperationListFetcher()
    let appliance: Appliance
    @Published var operations: [Operation] = []
    
    init(appliance: Appliance) {
        self.appliance = appliance
    }
    
    func fetch() {
        fetcher.fetchOperationList(appliance: appliance.id) { operations in
            self.operations = operations
        }
    }
    
    func send(operation: String, completion: @escaping (String) -> Void) {
        OperationSender().postOperation(appliance: appliance.id, operation: operation, completion: { result in
            completion(result)
        })
    }
}
