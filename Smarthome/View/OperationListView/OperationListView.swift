//
//  OperationListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct OperationListView: View {
    
    var appliance: Appliance
    var operations: [Operation] = MockData().mockOperations
    @State var isShowingAlert = false
    
    var body: some View {
        NavigationView {
            List(operations) { operation in
                Button (action: {
                    isShowingAlert = true
                }, label: {
                    OperationListViewCell(operation: operation)
                }).alert(isPresented: $isShowingAlert, content: {
                    Alert(title: Text("Alert"), message: Text("This is a message"))
                })
            }
            .navigationTitle("Operation List")
        }
    }
}

struct OperationListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationListView(appliance: MockData().mockAppliances[0])
    }
}
