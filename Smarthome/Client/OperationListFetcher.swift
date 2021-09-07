//
//  OperationListFetcher.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import Foundation

class OperationListFetcher: ObservableObject {
    
    var apiProperty = ApiProperty.shared
    private let url: String
    private let passPhrase: String
    
    init() {
        url = apiProperty.getString("URL") ?? "https://localhost"
        passPhrase = apiProperty.getString("passphrase") ?? ""
    }
    
    func fetchOperationList(appliance: String, completion: @escaping ([Operation]) -> Void) {
        let urlString = url + "/api/v1/" + appliance
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard let data = data else { return }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let operationListData = try decoder.decode([Operation].self, from: data)
                DispatchQueue.main.async {
                    completion(operationListData)
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
