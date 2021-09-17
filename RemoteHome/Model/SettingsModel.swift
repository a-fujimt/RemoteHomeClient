//
//  SettingsModel.swift
//  RemoteHome
//
//  Created by 藤本 章良 on 2021/09/09.
//

import Foundation

protocol SettingsModelProtocol {
    func fetchURL() -> String?
    func fetchPassPhrase() -> String?
    func updateURL(url: String)
    func updatePassPhrase(passPhrase: String)
}

class SettingsModel: SettingsModelProtocol {
    
    func fetchURL() -> String? {
        return UserDefaults.standard.string(forKey: "URL")
    }
    
    func fetchPassPhrase() -> String? {
        return UserDefaults.standard.string(forKey: "PassPhrase")
    }
    
    func updateURL(url: String) {
        UserDefaults.standard.set(url, forKey: "URL")
    }
    
    func updatePassPhrase(passPhrase: String) {
        UserDefaults.standard.set(passPhrase, forKey: "PassPhrase")
    }
    
}
