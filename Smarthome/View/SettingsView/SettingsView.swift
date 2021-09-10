//
//  SettingsView.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/09.
//

import SwiftUI

struct SettingsView: View {
    
    @ObservedObject var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        List {
            HStack{
                Text("URL")
                TextField("URL", text: $settingsViewModel.url)
                    .font(.callout)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.URL)
                    .autocapitalization(.none)
            }
            HStack{
                Text("Pass Phrase")
                SecureField("Pass Phrase", text: $settingsViewModel.passPhrase)
                    .font(.callout)
                    .multilineTextAlignment(.trailing)
            }
        }
        .navigationTitle("Settings")
        .onDisappear() {
            settingsViewModel.save()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
