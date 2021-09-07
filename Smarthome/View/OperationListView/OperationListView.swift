//
//  OperationListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct OperationListView: View {
    
//    var operations: [Operation] = MockData().mockOperations
    @ObservedObject var operationListViewModel: OperationListViewModel
    @State var isShowingAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    var body: some View {
        List(operationListViewModel.operations) { operation in
            Button (action: {
                alertTitle = operation.name
                operationListViewModel.send(operation: operation.id) { result in
                    self.isShowingAlert = true
                    alertMessage = result
                }
            }, label: {
                OperationListViewCell(operation: operation)
            }).alert(isPresented: $isShowingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage))
            }
        }
        .navigationTitle("Operation List")
        .onAppear() {
            operationListViewModel.fetch()
        }
    }
    
}

struct OperationListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationListView(operationListViewModel: OperationListViewModel(appliance: MockData().mockAppliances[0]))
    }
}
