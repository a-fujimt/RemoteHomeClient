//
//  SettingsModel.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/09.
//

import Foundation

protocol SettingsModelProtocol {
    func fetchURL() -> String
    func fetchPassPhrase() -> String
    func updateURL(url: String)
    func updatePassPhrase(passPhrase: String)
}

class SettingsModel: SettingsModelProtocol {
    
    var apiProperty = ApiProperty.shared
    
    func fetchURL() -> String {
        return apiProperty.getString("URL") ?? ""
    }
    
    func fetchPassPhrase() -> String {
        return apiProperty.getString("passphrase") ?? ""
    }
    
    func updateURL(url: String) {
        print(url)
    }
    
    func updatePassPhrase(passPhrase: String) {
        print(passPhrase)
    }
    
}
