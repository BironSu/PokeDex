//
//  ImageHelper.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/17/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

final class ImageHelper {
    private init() {
        imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100 // number of objects
        imageCache.totalCostLimit = 10 * 1024 * 1024 // max 10MB used
    }
    public static let shared = ImageHelper()
    
    private var imageCache: NSCache<NSString, UIImage>
    
    public func fetchImage(urlString: String, completionHandler: @escaping (AppError?, UIImage?) -> Void) {
        NetworkHelper.shared.performDataTask(endpointURLString: urlString, httpMethod: "GET", httpBody: nil) { (error, data, response) in
            if let response = response {
                // response.allHeaderFields dictionary contains useful header information such as Content-Type, Content-Length
                // response also has the mimeType, such as image/jpeg, text/html, image/png
                let mimeType = response.mimeType ?? "no mimeType found"
                var isValidImage = false
                switch mimeType {
                case "image/jpeg":
                    isValidImage = true
                case "image/png":
                    isValidImage = true
                default:
                    isValidImage = false
                }
                if !isValidImage {
                    completionHandler(AppError.badMimeType(mimeType), nil)
                    return
                }
            }
            guard let httpResponse = response,
                (200...299).contains(httpResponse.statusCode) else {
                    let statusCode = response?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode("\(statusCode), image not found"), nil)
                    return
            }
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    if let image = image {
                        ImageHelper.shared.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                    completionHandler(nil, image)
                }
            }
        }
    }
    
    public func image(forKey key: NSString) -> UIImage? {
        return imageCache.object(forKey: key)
    }
}
