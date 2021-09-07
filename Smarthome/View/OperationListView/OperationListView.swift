//
//  OperationListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct OperationListView: View {
    
    var appliance: Appliance
//    var operations: [Operation] = MockData().mockOperations
    @ObservedObject var fetcher = OperationListFetcher()
    @State var isShowingAlert = false
    @State var alertMessage = ""
    @State var alertTitle = ""
    
    var body: some View {
        NavigationView {
            List(fetcher.operations) { operation in
                Button (action: {
                    alertTitle = operation.name
                    OperationSender().postOperation(appliance: appliance.id, operation: operation.id, completion: { result in
                        isShowingAlert = true
                        alertMessage = result
                    })
                }, label: {
                    OperationListViewCell(operation: operation)
                }).alert(isPresented: $isShowingAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage))
                }
            }
            .navigationTitle("Operation List")
        }
        .onAppear() {
            fetcher.fetchOperationList(appliance: appliance.id)
        }
    }
    
}

struct OperationListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationListView(appliance: MockData().mockAppliances[0])
    }
}
