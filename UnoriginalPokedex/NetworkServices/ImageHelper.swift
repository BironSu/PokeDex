//
//  ImageHelper.swift
//  UnoriginalPokedex
//
//  Created by Biron Su on 12/17/18.
//  Copyright © 2018 Pursuit. All rights reserved.
//

import UIKit

final class ImageHelper {
    static func fetchImage(urlString: String, completionHandler: @escaping (Error?, UIImage?) -> Void) {
        NetworkHelper.performDataTask(urlString: urlString, httpMethod: "GET") { (error, data) in
            if let error = error {
                completionHandler(error, nil)
            } else if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    completionHandler(nil,image)
                }
            }
        }
    }
}
