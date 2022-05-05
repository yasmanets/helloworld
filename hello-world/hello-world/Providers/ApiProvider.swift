//
//  ApiProvider.swift
//  hello-world
//
//  Created by Yaser El Dabete Arribas on 5/5/22.
//

import Foundation

class ApiProvider {
    
    func genericDecoder<T: Codable>(_ type: T.Type, from data: Data) -> T? {
        let decoder = JSONDecoder()

        if let object = try? decoder.decode(type, from: data) {
            return object
        }
        return nil
    }
    
    
    func commonRequest<T:Codable>(entity: T.Type, url: String, method: Constants.HttpMethods, completion: @escaping (_ data: T?, _ error: Bool?) -> Void) {
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = method.rawValue
        request = ApiProvider.setCommonHeaders(&request)
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: {data, response, error -> Void in
            do {
                if let response = response as? HTTPURLResponse {
                    if response.statusCode != 200 {
                        completion(nil, true)
                    }
                }
                if data != nil {
                    let responseModel = self.genericDecoder(entity.self, from: data!)
                    if responseModel != nil {
                        completion(responseModel, false)
                    }
                    else {
                        completion(nil, true)
                    }
                }
            }
        })
        task.resume()
    }
    
    static func setCommonHeaders(_ request: inout URLRequest) -> URLRequest {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
