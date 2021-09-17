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
    @Published var isShowingAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    func fetch() {
        client.fetchApplianceList() { result in
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
                DispatchQueue.main.async {
                    self.appliances = []
                    self.isShowingAlert = true
                    self.alertTitle = "Error"
                    self.alertMessage = message
                }
            }
        }
    }
    
}
