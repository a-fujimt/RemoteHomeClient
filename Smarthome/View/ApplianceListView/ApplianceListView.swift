//
//  ApplianceListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct ApplianceListView: View {
    
//    let appliances: [Appliance] = MockData().mockAppliances
    @ObservedObject var applianceListViewModel = ApplianceListViewModel()
    @State var isShowingAlert = false
    @State var alert = Alert(title: Text(""))
    
    var body: some View {
        NavigationView {
            List(applianceListViewModel.appliances) { appliance in
                NavigationLink(destination: OperationListView(operationListViewModel: OperationListViewModel(appliance: appliance))) {
                    ApplianceListViewCell(appliance: appliance)
                }
            }
            .navigationTitle("Appliance List")
        }
        .alert(isPresented: $isShowingAlert, content: { alert })
        .onAppear() {
            applianceListViewModel.fetch() { (result, message) in
                if result == "Error" {
                    isShowingAlert = true
                    alert = Alert(title: Text(result), message: Text(message))
                }
            }
        }
    }
}

struct ApplianceListView_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceListView()
    }
}
