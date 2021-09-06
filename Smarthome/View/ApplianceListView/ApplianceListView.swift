//
//  ApplianceListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct ApplianceListView: View {
    
//    let appliances: [Appliance] = MockData().mockAppliances
    @ObservedObject var fetcher = DataFetcher()
    
    var body: some View {
        NavigationView {
            List(fetcher.appliances) { appliance in
                NavigationLink(destination: OperationListView(appliance: appliance, fetcher: fetcher)) {
                    ApplianceListViewCell(appliance: appliance)
                }
            }
            .navigationTitle("Appliance List")
        }
        .onAppear() {
            fetcher.fetchApplianceList()
        }
    }
}

struct ApplianceListView_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceListView()
    }
}
