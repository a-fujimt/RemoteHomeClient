//
//  ApplianceListViewModel.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

class ApplianceListViewModel: ObservableObject {
    
    let client = ApiClient()
    @Published var appliances: [Appliance] = []
    
    func fetch(completion: @escaping ((String, String)) -> Void) {
        client.fetchApplianceList() { result in
            switch result {
            case let .success(appliances):
                self.appliances = appliances
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
    
}
