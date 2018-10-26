//
//  PhotoDetailPresenter.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

protocol PhotoDetailPresenterInput: PhotoDetailInteractorOutput, PhotoDetailViewControllerOutput {
    
}

class PhotoDetailPresenter: PhotoDetailPresenterInput {
    
    var view: PhotoDetailViewControllerInput!
    var interactor: PhotoDetailInteractorInput!
    
    //Passing data from PhotoSearch Module
    func saveSelectedPhotoModel(photoModel: FlickrPhotoModel) {
        self.interactor.configurePhotoModel(photoModel: photoModel)
    }
    
    func loadLargePhotoImage() {
        self.interactor.loadUIImageFromURL()
    }
    
    //results from interactor
    func sendLoadedPhoto(image: UIImage) {
        self.view.addLargeLoadedPhoto(image: image)
    }
    
    func getPhotoImageTitle() {
        let imageTitle = self.interactor.getPhotoImageTitle()
        self.view.addPhotoImageTitle(imageTitle: imageTitle)
    }
}
