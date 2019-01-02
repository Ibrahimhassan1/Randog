//
//  DogApi.swift
//  Randog
//
//  Created by Ibrahim Hassan on 1/2/19.
//  Copyright © 2019 SoftUps, LLC. All rights reserved.
//

import Foundation
import UIKit

class DogApi {
    enum Endpoint: String {
        case randomImageFromAllDogsCollection = "https://dog.ceo/api/breeds/image/random"
        
        var url: URL {
            return URL(string: self.rawValue)!
        }
    }
    
    class func requestImageFile(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void){
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let downloadedImage = UIImage(data: data)
            completionHandler(downloadedImage, nil)
        })
        task.resume()
    }
    
    class func requestRandomImage(completionHandler: @escaping (DogImage?, Error?) -> Void ) {
        let randomImageEndpoint = DogApi.Endpoint.randomImageFromAllDogsCollection.url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) {(data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            print(data)
            do{
                let decoder = JSONDecoder()
                let dogImage = try decoder.decode(DogImage.self, from: data)
                print(dogImage)
                completionHandler(dogImage, nil)
            } catch {
                completionHandler(nil, error)
            }
        }
        task.resume()
    }
}
