//
//  BreedsListResponse.swift
//  Randog
//
//  Created by Ibrahim Hassan on 1/3/19.
//  Copyright © 2019 SoftUps, LLC. All rights reserved.
//

import Foundation

struct BreedsListResponse: Codable {
    let status: String
    let message: [String : [String]]
}
