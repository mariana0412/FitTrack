//
//  JsonUtils.swift
//  FitTrack
//
//  Created by Mariana Piz on 06.08.2024.
//

import Foundation

class JsonUtils {
    
    static func decode<T: Decodable>(fileName: String, type: T.Type, completion: @escaping (T?) -> Void) {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            completion(nil)
            return
        }

        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(T.self, from: data)
            
            completion(decodedData)
        } catch {
            print("Error parsing JSON: \(error)")
            completion(nil)
        }
    }
}
