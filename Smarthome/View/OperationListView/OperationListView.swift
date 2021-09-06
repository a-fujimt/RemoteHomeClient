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
    @ObservedObject var fetcher: DataFetcher
    @State var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            List(fetcher.operations) { operation in
                Button (action: {
                    isShowingAlert = true
                }, label: {
                    OperationListViewCell(operation: operation)
                }).alert(isPresented: $isShowingAlert, content: {
                    Alert(title: Text("Alert"), message: Text(operation.name))
                })
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
        OperationListView(appliance: MockData().mockAppliances[0], fetcher: DataFetcher())
    }
}
