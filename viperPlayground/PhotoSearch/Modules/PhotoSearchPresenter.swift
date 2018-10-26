//
//  PhotoSearchPresenter.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import UIKit

protocol PhotoSearchPresenterInput: PhotoViewControllerOutput, PhotoSearchInteractorOutput {
    
}

class PhotoSearchPresenter: PhotoSearchPresenterInput {
    
    var view: PhotoViewControllerInput!
    var interactor: PhotoSearchInteractorInput!
    var router: PhotoSearchRouterInput!
    
    //Presenter says interactor VC needs photos
    func fetchPhotos( searchTag: String, page: Int) {
        
        if view.getTotalPhotoCount() == 0 {
            view.showWaitingView()
        }
        
        interactor.fetchAllPhotosFromDataManager(searchTag, page)
    }
    
    //Service return photos and interactor passes all data to presenter which make view display them
    func providedPhotos( photos: [FlickrPhotoModel], totalPages: Int) {
        self.view.hideWaitingView()
        self.view.displayFetchedPhotos(photos: photos, totalPages: totalPages)
    }
    
    //Show error mesage from service
    func serviceError (error: NSError) {
        self.view.displayErrorView(error: error.localizedDescription)
    }
    
    func goToPhotoDetailScreen() {
        self.router.navigateToPhotoDetail()
    }
    
    func passDataToNextScene(segue: UIStoryboardSegue) {
        self.router.passDataToNextScene(segue: segue)
    }
    
}
