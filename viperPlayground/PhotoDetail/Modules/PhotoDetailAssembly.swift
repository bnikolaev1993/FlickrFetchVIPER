//
//  PhotoDetailAssembly.swift
//  viperPlayground
//
//  Created by Bogdan Nikolaev on 24/10/2018.
//  Copyright © 2018 Bogdan Nikolaev. All rights reserved.
//

import Foundation

class PhotoDetailAssembly {
    
    static let sharedInstance = PhotoDetailAssembly()
    
    func configure(viewController: PhotoDetailViewController) {
        let APIDataManager: FlickrPhotoLoadImageProtocol = FlickrDataManager()
        let interactor = PhotoDetailInteractor()
        let presenter = PhotoDetailPresenter()
        
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        presenter.interactor = interactor
        
        interactor.imageDataManager = APIDataManager
    }
    
}
