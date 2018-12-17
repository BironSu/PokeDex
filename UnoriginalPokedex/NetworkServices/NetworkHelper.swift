//
//  NetworkHelper.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/17/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

final class NetworkHelper {
    static func performDataTask(urlString: String, httpMethod: String, completionHandler: @escaping(Error?, Data?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("bad URL: \(urlString)")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                completionHandler(nil, data)
            }
        }.resume()
    }
}
