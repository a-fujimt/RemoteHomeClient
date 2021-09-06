//
//  ApiProperty.swift
//  Smarthome
//
//  Created by 藤本 章良 on 2021/09/06.
//

import Foundation

class ApiProperty {
    
    var property: Dictionary<String, Any> = [:]
    
    // シングルトン
    static let shared: ApiProperty = {
        let instance = ApiProperty()
        return instance
    }()

    
    init() {
        // API.plistのパス取得
        let path = Bundle.main.path(forResource: "API", ofType: "plist")
        // App.plistをDictionary形式で読み込み
        let configurations = NSDictionary(contentsOfFile: path!)
        if let datasourceDictionary: [String : Any]  = configurations as? [String : Any] {
            property = datasourceDictionary
        }
    }

    /// 指定されたキーの値を取得する
    /// - Parameter key: plistのキー
    func getString(_ key: String) -> String? {
        guard let value: String = property[key] as? String else {
            return nil
        }
        return value
    }
    
}
