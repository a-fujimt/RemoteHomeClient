//
//  ApplianceListViewModel.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/07.
//

import Foundation

class ApplianceListViewModel: ObservableObject {
    
    let fetcher = ApplianceListFetcher()
    @Published var appliances: [Appliance] = []
    
    func fetch() {
        fetcher.fetchApplianceList() { appliances in
            self.appliances = appliances
        }
    }
    
}
