//
//  ApiClient.swift
//  RemoteHome
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
    
    var settingsModel = SettingsModel()
    
    func fetchApplianceList(completion: @escaping (Result<[Appliance], Error>) -> Void) {
        guard let host = settingsModel.fetchURL() else { return }
        if host == "" { return }
        let urlString = host + "/api/v1/list"
        guard let url = URL(string: urlString) else {
            completion(.failure(ApiError.wrongUrl))
            return
        }
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                handleURLError(error: error, completion: completion)
                return
            }
            guard let data = data else { return }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let applianceListData = try decoder.decode([Appliance].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(applianceListData))
                }
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
                handleError(data: data, response: response, completion: completion)
            }
        }.resume()
    }
    
    func fetchOperationList(appliance: String, completion: @escaping (Result<[Operation], Error>) -> Void) {
        guard let host = settingsModel.fetchURL() else { return }
        if host == "" { return }
        let urlString = host + "/api/v1/" + appliance
        guard let url = URL(string: urlString) else {
            completion(.failure(ApiError.wrongUrl))
            return
        }
        URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            if let error = error {
                handleURLError(error: error, completion: completion)
                return
            }
            guard let data = data else { return }
            let decoder: JSONDecoder = JSONDecoder()
            do {
                let operationListData = try decoder.decode([Operation].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(operationListData))
                }
            } catch {
                print("json convert failed in JSONDecoder. " + error.localizedDescription)
                handleError(data: data, response: response, completion: completion)
            }
        }.resume()
    }
    
    func postOperation(appliance: String, operation: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let host = settingsModel.fetchURL() else { return }
        if host == "" { return }
        let urlString = host + "/api/v1/" + appliance + "/" + operation
        guard let url = URL(string: urlString) else {
            completion(.failure(ApiError.wrongUrl))
            return
        }
        var request = URLRequest(url: url)
        let passPhrase = settingsModel.fetchPassPhrase()
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
        
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            if let error = error {
                handleURLError(error: error, completion: completion)
                return
            }
            guard let data = data else { return }
            let value = String(data: data, encoding: .utf8)!
            if value == "OK" {
                completion(.success(value))
                return
            }
            handleError(data: data, response: response, completion: completion)
        }.resume()
    }
    
    private func handleURLError<T>(error: Error, completion: @escaping (Result<T, Error>) -> Void) {
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorCannotFindHost:
            completion(.failure(ApiError.wrongUrl))
        case NSURLErrorTimedOut:
            completion(.failure(ApiError.timeOut))
        default:
            completion(.failure(ApiError.unknown(error)))
        }
    }
    
    private func handleError<T>(data: Data, response: URLResponse?, completion: @escaping (Result<T, Error>) -> Void) {
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
    }
    
}
