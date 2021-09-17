//
//  ApplianceListViewModel.swift
//  RemoteHome
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
                DispatchQueue.main.async {
                    self.appliances = []
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
    
}
