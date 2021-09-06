//
//  OperationListViewCell.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct OperationListViewCell: View {
    
    var operation: Operation
    
    var body: some View {
        Text(operation.name)
    }
}

struct OperationListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        OperationListViewCell(operation: Operation(id: "id", name: "name"))
    }
}
