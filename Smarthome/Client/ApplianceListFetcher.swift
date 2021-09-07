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
    
    init() {
        url = apiProperty.getString("URL") ?? "https://localhost"
        passPhrase = apiProperty.getString("passphrase") ?? ""
    }
    
    func fetchApplianceList(completion: @escaping (Result<[Appliance], Error>) -> Void) {
        let urlString = url + "/api/v1/list"
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard let data = data else { return }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let applianceListData = try decoder.decode([Appliance].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(applianceListData))
                }
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
                do {
                    let apiErrorData = try decoder.decode(ApiErrorModel.self, from: data)
                    print(apiErrorData.error.message)
                    if let response = response as? HTTPURLResponse {
                        completion(.failure(ApiError.server(response.statusCode, apiErrorData.error.message)))
                        return
                    }
                    completion(.failure(ApiError.noResponse))
                } catch {
                    print("json convert failed in JSONDecoder. " + error.localizedDescription)
                    completion(.failure(ApiError.decoder(error)))
                }
            }
        }.resume()
    }
    
}
