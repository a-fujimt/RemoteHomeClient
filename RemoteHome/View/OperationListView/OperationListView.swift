//
//  OperationListView.swift
//  RemoteHome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct OperationListView: View {
    
//    var operations: [Operation] = MockData().mockOperations
    @ObservedObject var operationListViewModel: OperationListViewModel
    @State var isShowingAlert = false
    @State var alert = Alert(title: Text(""))
    
    var body: some View {
        List(operationListViewModel.operations) { operation in
            Button (action: {
                operationListViewModel.send(operation: operation.id) { (result, message) in
                    self.isShowingAlert = true
                    if message == "" {
                        alert = Alert(title: Text(result))
                    } else {
                        alert = Alert(title: Text(result), message: Text(message))
                    }
                }
            }, label: {
                OperationListViewCell(operation: operation)
            })
        }.alert(isPresented: $isShowingAlert, content: { alert })
        .navigationTitle("Operation List")
        .onAppear() {
            operationListViewModel.fetch() { (result, message) in
                if result == "Error" {
                    isShowingAlert = true
                    alert = Alert(title: Text(result), message: Text(message))
                }
            }
        }
    }
    
}

struct OperationListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationListView(operationListViewModel: OperationListViewModel(appliance: MockData().mockAppliances[0]))
    }
}
