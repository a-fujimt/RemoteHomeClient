//
//  DataFetcher.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import Foundation

class DataFetcher: ObservableObject {
    
    var apiProperty = ApiProperty.shared
    private let url: String
    private let passPhrase: String
    
    @Published var appliances: [Appliance] = []
    @Published var operations: [Operation] = []
    
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
                let searchedResultData = try decoder.decode([Appliance].self, from: data)
                DispatchQueue.main.async {
                    self.appliances = searchedResultData.reversed()
                }
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchOperationList(appliance: String) {
        let urlString = url + "/api/v1/" + appliance
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard let data = data else { return }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let searchedResultData = try decoder.decode([Operation].self, from: data)
                DispatchQueue.main.async {
                    self.operations = searchedResultData.reversed()
                }
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
            }
        }.resume()
    }
    
}
