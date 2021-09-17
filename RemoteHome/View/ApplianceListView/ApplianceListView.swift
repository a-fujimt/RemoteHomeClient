//
//  ApplianceListView.swift
//  RemoteHome
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
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    NavigationLink(
                        destination: SettingsView()
                                    .onDisappear() { appear() },
                        label: { Text("Settings") })
                }
            }
            .navigationTitle("Appliance List")
        }
        .alert(isPresented: $applianceListViewModel.isShowingAlert, content: { Alert(title: Text(applianceListViewModel.alertTitle), message: Text(applianceListViewModel.alertMessage)) })
        .onAppear() {
            appear()
        }
    }
    
    private func appear() {
        applianceListViewModel.fetch()
    }
    
}

struct ApplianceListView_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceListView()
    }
}
