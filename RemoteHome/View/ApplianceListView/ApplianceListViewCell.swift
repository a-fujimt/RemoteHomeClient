//
//  ApplianceListViewCell.swift
//  RemoteHome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import SwiftUI

struct ApplianceListViewCell: View {
    
    var appliance: Appliance
    
    var body: some View {
        Text(appliance.name)
    }
}

struct ApplianceListViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ApplianceListViewCell(appliance: Appliance(id: "id", name: "name"))
    }
}
