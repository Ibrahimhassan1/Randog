
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
    @IBOutlet weak var pickerView: UIPickerView!
    
    var breeds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogApi.requestBreedsList(completionHandler: self.handleBreedsListResponse)
        
    }
    
    func handleBreedsListResponse(breeds: [String], error: Error?) {
        self.breeds = breeds
        DispatchQueue.main.async {
            self.pickerView.reloadAllComponents()
        }
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

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(DogApi.Endpoint.randomImageFromAllDogsCollection.url)
        DogApi.requestRandomImage (breed: breeds[row], completionHandler: handleRandomImageResponse(imageData:error:))
    }
}
