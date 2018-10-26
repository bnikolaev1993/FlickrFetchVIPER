//
//  FlickrPhotoModel.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

struct FlickrPhotoModel: Codable {
    let photoId : String
    let farm : Int
    let secret: String
    let server: String
    let title: String
    
//    enum CodingKeys: String, CodingKey {
//        case photoId = "id"
//        case farm
//        case secret
//        case server
//        case title
//    }
//
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        photoId = try container.decode(String.self, forKey: .photoId)
//        farm = try container.decode(Int.self, forKey: .farm)
//        secret = try container.decode(String.self, forKey: .secret)
//        server = try container.decode(String.self, forKey: .server)
//        title = try container.decode(String.self, forKey: .title)
//    }
    
    var photoURL: URL {
        return flickrImageURL()
    }
    
    var largePhotoURL: URL {
        return flickrImageURL(size: "b")
    }
    
    private func flickrImageURL (size: String = "m") -> URL {
        guard let url = URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoId)_\(secret)_\(size).jpg") else {
            return URL(string: "")!
        }
        return url
    }
}
