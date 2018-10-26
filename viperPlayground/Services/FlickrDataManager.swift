//
//  FlickrDataManager.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import SDWebImage

protocol FlickrPhotoSearchProtocol {
    func fetchPhotosFor (searchText: String, page: Int, closure: @escaping (NSError?, Int, [FlickrPhotoModel]?) -> Void)
}

protocol FlickrPhotoLoadImageProtocol {
     func loadImageFromURL(url: URL, closure: @escaping (UIImage?, Error?) -> Void)
}

class FlickrDataManager: FlickrPhotoSearchProtocol, FlickrPhotoLoadImageProtocol {
    
    struct Errors {
        static let invalidAccessErrorCode = 100
    }
    
    struct FlickrResponseKeys {
        static let code = "code"
        static let photos = "photos"
        static let total = "total"
        static let photo = "photo"
    }
    
    let APIKey: String = "90a890fc2a79a75d4ff380d5f33e2452"
    let tagsSearchFormat = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&tags=%@&page=%i&format=json&nojsoncallback=1"
    
    func fetchPhotosFor (searchText: String, page: Int, closure: @escaping (NSError?, Int, [FlickrPhotoModel]?) -> Void) {
        
        guard let escapedSearchedText = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return
        }
        
        let format = tagsSearchFormat
        let argument: [CVarArg] = [APIKey, escapedSearchedText, page]
        
        let photosURL = String(format: format, arguments: argument)
        print(photosURL)
        
        guard let url = URL(string: photosURL) else {
            return
        }
        print(url.absoluteURL)
        let request = URLRequest(url: url)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let searchTask = session.dataTask(with: request) { (data, response, error) in
            
            if (error != nil) {
                print("ERROR! FEtching photos failed: \(error.debugDescription)")
                closure(error as NSError?, 0 , nil)
                return
            }
            
            do {
                
                guard let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String : AnyObject] else {
                    print("Error! JSON Serialization Error!")
                    return
                }
                
                if let statusCode = resultsDictionary[FlickrResponseKeys.code] as? Int {
                    if statusCode == Errors.invalidAccessErrorCode {
                        let invalidAccessError = NSError(domain: "FlickrAPIDomain", code: statusCode, userInfo: nil)
                        closure(invalidAccessError, 0, nil)
                        return
                    }
                }
                
                guard let photos = resultsDictionary[FlickrResponseKeys.photos] as? NSDictionary else { return }
                guard let totalPageString = photos[FlickrResponseKeys.total] as? String else { return }
                guard let totalPageInt = Int(totalPageString) else { return }
                guard let photosArray = photos[FlickrResponseKeys.photo] as? [NSDictionary] else { return }
                
                let flickrPhotos: [FlickrPhotoModel] = photosArray.map({ (photoDictionary) -> FlickrPhotoModel in
                    
                    let photoId = photoDictionary["id"] as? String ?? ""
                    let farm = photoDictionary["farm"] as? Int ?? 0
                    let secret = photoDictionary["secret"] as? String ?? ""
                    let server = photoDictionary["server"] as? String ?? ""
                    let title = photoDictionary["title"] as? String ?? ""
                    
                    let flickrPhoto = FlickrPhotoModel(photoId: photoId, farm: farm, secret: secret, server: server, title: title)
                    
                    return flickrPhoto
                })
                
                closure(nil, totalPageInt, flickrPhotos)
                
            } catch let error as NSError {
                print("Error parsing JSON: \(error)")
                closure(error, 0, nil)
                return
            }
            
        }
        searchTask.resume()
        
    }
    
    //Memory cache photo service
    
    func loadImageFromURL(url: URL, closure: @escaping (UIImage?, Error?) -> Void) {
        SDWebImageManager.shared().loadImage(with: url, options: .retryFailed, progress: nil) { (image, data, error, cache, finished, withURL) in
            if (image != nil) && finished {
                closure(image, nil)
            }
        }
    }
}
