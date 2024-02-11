//
//  ApplianceListViewModel.swift
//  RemoteHome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

class ApplianceListViewModel: ObservableObject {
    
    let client = ConcurrncyApiClient()
    @Published var appliances: [Appliance] = []
    @Published var isShowingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @MainActor
    func fetch () async {
        let result = await client.fetchApplianceList()
        
        switch result {
        case let .success(appliances):
            self.appliances = appliances
        case let .failure(error):
            let message: String
            if let apiError = error as? ApiError {
                message = apiError.getErrorDetail()
            } else {
                message = "Error"
            }
            self.appliances = []
            self.isShowingAlert = true
            self.alertTitle = "Error"
            self.alertMessage = message
        }
    }
    
}
