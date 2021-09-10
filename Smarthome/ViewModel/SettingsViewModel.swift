//
//  SettingsViewModel.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/09.
//

import Foundation

class SettingsViewModel: ObservableObject {
    
    private let model: SettingsModel
    @Published var url: String
    @Published var passPhrase: String
    
    init() {
        model = SettingsModel()
        url = model.fetchURL() ?? ""
        passPhrase = model.fetchPassPhrase() ?? ""
    }
    
    func save() {
        model.updateURL(url: url)
        model.updatePassPhrase(passPhrase: passPhrase)
    }
    
}
