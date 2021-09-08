//
//  ApiClient.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/08.
//

import Foundation

protocol ApiClientProtocol {
    func fetchApplianceList(completion: @escaping (Result<[Appliance], Error>) -> Void)
    func fetchOperationList(appliance: String, completion: @escaping (Result<[Operation], Error>) -> Void)
    func postOperation(appliance: String, operation: String, completion: @escaping (Result<String, Error>) -> Void)
}

class ApiClient: ApiClientProtocol {
    
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
    
    func fetchOperationList(appliance: String, completion: @escaping (Result<[Operation], Error>) -> Void) {
        let urlString = url + "/api/v1/" + appliance
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, response, error) in
            guard let data = data else { return }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let operationListData = try decoder.decode([Operation].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(operationListData))
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
    
    func postOperation(appliance: String, operation: String, completion: @escaping (Result<String, Error>) -> Void) {
        let urlString = url + "/api/v1/" + appliance + "/" + operation
        var request = URLRequest(url: URL(string: urlString)!)
        let jsonBody = ["passphrase" : passPhrase]
        do {
            let data = try JSONSerialization.data(withJSONObject: jsonBody, options: [])
            request.httpMethod = "POST"      // Send POST request
            request.httpBody = data
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
        } catch {
            print("json convert failed in JSONSerialization. " + error.localizedDescription)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else { return }
            let value = String(data: data, encoding: .utf8)!
            if value == "OK" {
                completion(.success(value))
                return
            }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let apiErrorData = try decoder.decode(ApiErrorModel.self, from: data)
                let errorMessage = apiErrorData.error.message
                print(apiErrorData.error.message)
                if let response = response as? HTTPURLResponse {
                    completion(.failure(ApiError.server(response.statusCode, errorMessage)))
                    return
                }
                completion(.failure(ApiError.noResponse))
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
                completion(.failure(ApiError.decoder(error)))
            }
        }.resume()
    }
    
}
