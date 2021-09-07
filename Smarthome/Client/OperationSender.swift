//
//  OperationSender.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import Foundation

class OperationSender: ObservableObject {
    
    var apiProperty = ApiProperty.shared
    private let url: String
    private let passPhrase: String
    
    @Published var status = ""
    @Published var message = ""
    
    init() {
        url = apiProperty.getString("URL") ?? "https://localhost"
        passPhrase = apiProperty.getString("passphrase") ?? ""
    }
    
    func postOperation(appliance: String, operation: String, completion: @escaping(String) -> Void) {
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
                completion(value)
                return
            }
            do {
                let errorData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String: Any]
                let errorDetail = errorData["error"] as! [String: Any]
                let errorMessage = errorDetail["message"] as! String
                if let response = response as? HTTPURLResponse {
                    completion(errorMessage + "(" + String(response.statusCode) + ")")
                }
            } catch {
                completion(value)
            }
        }.resume()
    }
    
}
