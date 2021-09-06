//
//  ApplianceListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct ApplianceListView: View {
    
    let appliances: [Appliance] = MockData().mockAppliances
    
    var body: some View {
        NavigationView {
            List(appliances) { appliance in
                NavigationLink(destination: OperationListView(appliance: appliance)) {
                    ApplianceListViewCell(appliance: appliance)
                }
            }
            .navigationTitle("Appliance List")
        }
    }
}

struct ApplianceListView_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceListView()
    }
}
