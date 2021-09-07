//
//  ApplianceListFetcher.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import Foundation

class ApplianceListFetcher: ObservableObject {
    
    var apiProperty = ApiProperty.shared
    private let url: String
    private let passPhrase: String
    
    @Published var appliances: [Appliance] = []
    
    init() {
        url = apiProperty.getString("URL") ?? "https://localhost"
        passPhrase = apiProperty.getString("passphrase") ?? ""
    }
    
    func fetchApplianceList() {
        let urlString = url + "/api/v1/list"
        print(urlString)
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard let data = data else { return }
            print(data)
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let applianceListData = try decoder.decode([Appliance].self, from: data)
                DispatchQueue.main.async {
                    self.appliances = applianceListData.reversed()
                }
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
                do {
                    let apiErrorData = try decoder.decode(ApiError.self, from: data)
                    print(apiErrorData.error.message)
                } catch {
                    print("json convert failed in JSONDecoder. " + error.localizedDescription)
                }
            }
        }.resume()
    }
    
}
