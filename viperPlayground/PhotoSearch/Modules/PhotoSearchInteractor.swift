//
//  PhotoSearchInteractor.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

protocol PhotoSearchInteractorInput {
    func fetchAllPhotosFromDataManager(_ searchTag: String, _ page: Int)
}

protocol PhotoSearchInteractorOutput {
    
    func providedPhotos( photos: [FlickrPhotoModel], totalPages: Int)
    func serviceError (error: NSError)
}

class PhotoSearchInteractor: PhotoSearchInteractorInput {

    var presenter: PhotoSearchInteractorOutput!
    var APIDataManager: FlickrPhotoSearchProtocol!
    
    func fetchAllPhotosFromDataManager(_ searchTag: String, _ page: Int) {
        APIDataManager.fetchPhotosFor(searchText: searchTag, page: page) { (error, page, flickrPhotos) in
            if let photos = flickrPhotos {
                self.presenter.providedPhotos(photos: photos, totalPages: page)
            } else if let error = error {
                self.presenter.serviceError(error: error)
            }
        }
    }
}
