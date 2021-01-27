//
//  APIManager.swift
//  Popcorn
//
//  Created by Front-Artist on 2020/10/29.
//

import Alamofire

typealias APIResponse<T> = Swift.Result<T, Error>

class APIManager {
    static func request<T: Decodable>(_ api: String, method: HTTPMethod, params: [String: Any]?, Localization: Bool = true, progress: Bool = true, responseType: T.Type, response: @escaping (APIResponse<T>) -> Void) {
        guard let url = URL(string: AppConstants.Domain.tmdbAPI + api) else {
            Log.e(AppConstants.Domain.tmdbAPI + api)
            return
        }
        
        var requestParams = params ?? [:]
        requestParams["api_key"] = AppConstants.Key.tmdb
        if Localization {
            requestParams["language"] = "ko"
            requestParams["region"] = "KR"
        }
        var hTTPHeaders = HTTPHeaders.init()
        hTTPHeaders["Accept"] = "application/json"
        let manager = Alamofire.Session.default
        
        manager.request(url, method: method, parameters: requestParams, encoding: URLEncoding.default, headers: hTTPHeaders).validate().responseJSON { (responseData) in
            Log.d(url)

            switch responseData.result{
            case .success(let successData):
                do {
                    let data = try JSONSerialization.data(withJSONObject: successData, options: .prettyPrinted)
                    Log.d("JSON: \(String(decoding: data, as: UTF8.self))")
                    
                    let object = try JSONDecoder().decode(responseType, from: data)
                    response(.success(object))
                } catch let error {
                    Log.e(error)
                    response(.failure(error))
                }
            case .failure(let error):
                Log.e(error)
                response(.failure(error))
            }
        }
    }
}
