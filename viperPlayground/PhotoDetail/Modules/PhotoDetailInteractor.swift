//
//  PhotoDetailInteractor.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation
import UIKit

protocol PhotoDetailInteractorOutput {
    func sendLoadedPhoto(image: UIImage)
}

protocol PhotoDetailInteractorInput {
    func configurePhotoModel(photoModel: FlickrPhotoModel)
    func loadUIImageFromURL()
    func getPhotoImageTitle() -> String
}

class PhotoDetailInteractor: PhotoDetailInteractorInput {
    
    var presenter: PhotoDetailInteractorOutput!
    var imageDataManager: FlickrPhotoLoadImageProtocol!
    var photoModel: FlickrPhotoModel?
    
    func configurePhotoModel(photoModel: FlickrPhotoModel) {
        self.photoModel = photoModel
    }
    
    func loadUIImageFromURL() {
        imageDataManager.loadImageFromURL(url: (self.photoModel?.largePhotoURL)!) { (image, error) in
            if let image = image {
                self.presenter.sendLoadedPhoto(image: image)
            }
        }
    }
    
    func getPhotoImageTitle() -> String {
        if let title = self.photoModel?.title {
            return title
        }
        return ""
    }
}
