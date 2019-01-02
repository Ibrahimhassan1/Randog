
//
//  ViewController.swift
//  Randog
//
//  Created by Ibrahim Hassan on 1/2/19.
//  Copyright © 2019 SoftUps, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(DogApi.Endpoint.randomImageFromAllDogsCollection.url)
        DogApi.requestRandomImage (completionHandler: handleRandomImageResponse(imageData:error:))
        
    }
    
    func handleRandomImageResponse(imageData: DogImage?, error: Error?) {
        guard let imageUrl = URL(string: imageData?.message ?? "") else {
            return
        }
        DogApi.requestImageFile(url: imageUrl, completionHandler: self.handleImageFileRequest(image:error:))
    }
    
    func handleImageFileRequest(image: UIImage?, error: Error?){
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

