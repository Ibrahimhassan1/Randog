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
    enum Endpoint {
        case randomImageFromAllDogsCollection
        case randomImageForBreed(String)
        case listAllBreeds
        
        var url: URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomImageFromAllDogsCollection:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomImageForBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllBreeds:
                return "https://dog.ceo/api/breeds/list/all"
            }
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
    
    class func requestRandomImage(breed: String, completionHandler: @escaping (DogImage?, Error?) -> Void ) {
        let randomImageEndpoint = DogApi.Endpoint.randomImageForBreed(breed).url
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
    
    class func requestBreedsList(completionHandler: @escaping ([String], Error?)-> Void) {
        let requestBreedListEndpoint = DogApi.Endpoint.listAllBreeds.url
        let task = URLSession.shared.dataTask(with: requestBreedListEndpoint) {
            (data, response, error) in
            guard let data = data else {
                completionHandler([], error)
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let breedsResponse = try decoder.decode(BreedsListResponse.self, from: data)
                let breeds = breedsResponse.message.keys.map({$0})
            
                completionHandler(breeds, nil)
            } catch {
                print(error)
            }
        }
        task.resume()
        
    }
}
