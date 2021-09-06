//
//  OperationListView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct OperationListView: View {
    
    var operations: [Operation] = MockData().mockOperations
    
    var body: some View {
        NavigationView {
            List(operations) { operation in
                OperationListViewCell(operation: operation)
            }
            .navigationTitle("Operation List")
        }
    }
}

struct OperationListView_Previews: PreviewProvider {
    static var previews: some View {
        OperationListView()
    }
}
