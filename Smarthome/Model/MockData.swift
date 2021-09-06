//
//  MockData.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import Foundation

struct MockData {
    
    let mockOperations: [Operation]
    let mockAppliances: [Appliance]
    
    init() {
        mockOperations = [Operation(id: "on", name: "ON"),
                          Operation(id: "off", name: "OFF")]
        mockAppliances = [Appliance(id: "tv",
                                    name: "TV"),
                          Appliance(id: "light",
                                    name: "Light")
                          ]
    }
    
}
