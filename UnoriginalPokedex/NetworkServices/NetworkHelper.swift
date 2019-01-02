//
//  NetworkHelper.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/17/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import Foundation

//final class NetworkHelper {
//    static func performDataTask(urlString: String, httpMethod: String, completionHandler: @escaping(Error?, Data?) -> Void) {
//        guard let url = URL(string: urlString) else {
//            print("bad URL: \(urlString)")
//            return
//        }
//        var request = URLRequest(url: url)
//        request.httpMethod = httpMethod
//
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                completionHandler(error, nil)
//            } else if let data = data {
//                completionHandler(nil, data)
//            }
//        }.resume()
//    }
//}

// BELOW IS ALEX'S CODE
final class NetworkHelper {
    private init() {
        let cache = URLCache(memoryCapacity: 10 * 1024 * 1024, diskCapacity: 10 * 1024 * 1024, diskPath: nil)
        URLCache.shared = cache
    }
    public static let shared = NetworkHelper()
    
    public func performDataTask(endpointURLString: String,
                                httpMethod: String,
                                httpBody: Data?,
                                completionHandler: @escaping (AppError?, Data?, HTTPURLResponse?) ->Void) {
        guard let url = URL(string: endpointURLString) else {
            completionHandler(AppError.badURL("\(endpointURLString)"), nil, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completionHandler(AppError.networkError(error), nil, response as? HTTPURLResponse)
                return
            }
            guard let _ = response as? HTTPURLResponse else {
                completionHandler(AppError.badStatusCode((response as? HTTPURLResponse)?.statusCode.description ?? "bad response"), nil, nil)
                return
            }
            if let data = data {
                completionHandler(nil, data, response as? HTTPURLResponse)
            }
            }.resume()
    }
    
    public func performUploadTask(endpointURLString: String,
                                  httpMethod: String,
                                  httpBody: Data?,
                                  completionHandler: @escaping (AppError?, Data?, HTTPURLResponse?) ->Void) {
        guard let url = URL(string: endpointURLString) else {
            completionHandler(AppError.badURL("\(endpointURLString)"), nil, nil)
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.uploadTask(with: request, from: httpBody) { (data, response, error) in
            if let error = error {
                completionHandler(AppError.networkError(error), nil, response as? HTTPURLResponse)
                return
            }
            guard let _ = response as? HTTPURLResponse else {
                completionHandler(AppError.badStatusCode((response as? HTTPURLResponse)?.statusCode.description ?? "bad response"), nil, nil)
                return
            }
            if let data = data {
                completionHandler(nil, data, response as? HTTPURLResponse)
            }
            }.resume()
    }
}
